import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Model extends ChangeNotifier {
  FirebaseFirestore fb_store = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  bool _isProcessing = false;
  int _registered = 0;
  int _users = 0;
  int _selectedScreen = 0;
  User? _user;
  String _name = "";
  String _str = "";
  String _spinnerVal = "24H";
  List<String> _sender = [];
  List<String> _userInfo = [];
  List<String> _gymInfo = [];
  List<String> _gNames = [];
  var uniqueSet = <String>{};
  List<String> _selectedWeekdays = [
    "Monday,",
    "Tuesday,",
    "Wednesday,",
    "Thursday,",
    "Friday,",
    "Saturday,",
    "Sunday,"
  ];
  String _weekdays = "";
  bool get isProcessing => _isProcessing;
  int get registered => _registered;
  int get users => _users;
  String get name => _name;
  String get str => _str;
  String get spinnerVal => _spinnerVal;
  User? get user => _user;
  List<String> get sender => _sender;
  List<String> get userInfo => _userInfo;
  List<String> get gymInfo => _gymInfo;
  List<String> get gNames => _gNames;
  List<String> get selectedWeekdays => _selectedWeekdays;
  String get weekdays => _weekdays;
  int get selectedScreen => _selectedScreen;

  processingData(bool process) {
    if(process) {
      _isProcessing = true;
    } else if(!process) {
      _isProcessing = false;
    }
    notifyListeners();
  }

  processingAccState(int n) {
    _registered = n;
    notifyListeners();
  }

  Future<User?> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        hideSnackbar(context);
        showSnackbar(context, "No user found for that email.");
        return null;
      } else if (e.code == 'wrong-password') {
        hideSnackbar(context);
        showSnackbar(context, "Wrong password provided.");
        return null;
      }
    }
    return _user;
  }

  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _name = name;
      _user = userCredential.user;
      await _user!.updateDisplayName(name);
      await _user?.reload();
      _user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        hideSnackbar(context);
        showSnackbar(context, "Password is too weak");
        return null;
      } else if (e.code == 'email-already-in-use') {
        hideSnackbar(context);
        showSnackbar(context, "The account already exists for that email.");
        return null;
      }
    }

    return _user;
  }

  signOut(BuildContext context) async {
    await auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
    notifyListeners();
  }

  resetPassword({required String email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  showSnackbar(BuildContext context, String str, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(str,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: (color != null) ? color : Colors.red));
  }

  hideSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void addUserInfo(String name, String email, String gender) async {
    await fb_store.collection("userinfo").doc(email).set({
      "name": name,
      "gender": gender,
      "email": email,
      "gymName": "",
      "admin": (email.contains("gym") || email.contains("admin")) ? true : false,
    });
  }

  getUserInfo() async {
    var doc = await fb_store.collection("userinfo").doc(auth.currentUser?.email).get();
    _userInfo.add(doc.data()!["name"]);
    _userInfo.add(doc.data()!["email"]);
    _userInfo.add(doc.data()!["gender"]);
    _userInfo.add(doc.data()!["gymName"]);
    _userInfo.add(doc.data()!["admin"].toString());
    notifyListeners();
    return _userInfo;
  }

  addUserGymInfo(String gymName, {String email = "", bool isAdmin = false}) async {
    if(isAdmin && email.isNotEmpty) {
      await fb_store.collection("userinfo").doc(email).update ({
        "gymName": gymName
      });
    } else if(!isAdmin && email.isEmpty) {
      await fb_store.collection("userinfo").doc(auth.currentUser?.email).update ({
        "gymName": gymName
      });
    }
    _userInfo[3] = gymName;
  }

  void manageDays(bool isSelected, String weekday, int i) {
    if(isSelected) {
      _selectedWeekdays.remove(weekday);
    } else {
      _selectedWeekdays.insert(i, weekday);
    }
    _weekdays = _selectedWeekdays.join();
  }

  void addGymInfo(String name, String location, String admin, String activeHours, double price, String weekdays) async {
    bool exists = false;
    await fb_store.collection("userinfo").doc(admin).update({
      "gymName": name,
    });

    fb_store.collection("gyminfo").doc(name).get().then((docSnapshot) => {
      exists = !docSnapshot.exists
    });

    if(!exists) {
      await fb_store.collection("gyminfo").doc(name).set({
        "name": name,
        "location": location,
        "admin": admin,
        "activeHours": activeHours,
        "price": price,
        "daysThatIsOpened": weekdays,
      });
    }
  }

  getGymInfo(String str) async {
    if(_gymInfo.isNotEmpty) {
      _gymInfo = [];
    }
    var doc = await fb_store.collection("gyminfo").doc(str).get();
    _gymInfo.add(doc.data()!["name"]);
    _gymInfo.add(doc.data()!["location"]);
    _gymInfo.add(doc.data()!["activeHours"]);
    _gymInfo.add(doc.data()!["price"].toString());
    _gymInfo.add(doc.data()!["admin"]);
    _gymInfo.add(doc.data()!["daysThatIsOpened"]);
    notifyListeners();
    return _gymInfo;
  }

  updateToggleButton(List lBool, int index, List lString) {
    for (int i = 0; i < lBool.length; i++) {
      lBool[i] = i == index;
    }
    _str = (lBool[0]) ? lString[0] : lString[1];
    notifyListeners();
    return lBool;
  }

  changeSpinnerValue(value) {
    _spinnerVal = value;
    notifyListeners();
  }

  getUsers() async {
    QuerySnapshot<Map<String, dynamic>> query = await fb_store.collection("chat-${_userInfo[3]}").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = query.docs;
    for(QueryDocumentSnapshot<Map<String, dynamic>> element in documents) {
      sender.add(element.data()['sender']);
      sender.where((email) => uniqueSet.add(email)).toList();
      _users = uniqueSet.length;
    }
    notifyListeners();
  }

  getGyms() async {
    QuerySnapshot<Map<String, dynamic>> query = await fb_store.collection("gyminfo").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = query.docs;
    for(QueryDocumentSnapshot<Map<String, dynamic>> element in documents) {
      gNames.add(element.data()['name']);
    }
    notifyListeners();
  }

  void sendMsg(String message, int index, bool edit) {
    String name;
    if(_userInfo[4] == "true") {
      name = "${_userInfo[0]} (Trainer)";
    } else {
      name = _userInfo[0];
    }
    if(edit) {
      fb_store.collection("chat-${_userInfo[3]}").doc("doc$index").update({
        "message": message,
        "modified": true,
      });
    } else {
      fb_store.collection("chat-${_userInfo[3]}").doc("doc$index").set({
        "sender": name,
        "senderMail": auth.currentUser!.email,
        "message": message,
        "timestamp": FieldValue.serverTimestamp(),
        "modified": false,
      });
    }
  }

  Stream<QuerySnapshot> getMessages() {
    Stream<QuerySnapshot> snapshots = fb_store.collection("chat-${_userInfo[3]}").orderBy("timestamp", descending: false).snapshots();
    getUsers();
    return snapshots;
  }

  changeScreen(int selected) {
    _selectedScreen = selected;
  }
}
