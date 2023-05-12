import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife/screens/loginregister.dart';
import 'package:flutter/material.dart';

class Model extends ChangeNotifier {
  FirebaseFirestore fbStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  bool _isProcessing = false;
  bool _postToAddIsForAdmin = true;
  int _registered = 0;
  int _users = 0;
  int _selectedScreen = 0;
  int _addingPostExerciseScreen = 0;
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
  List<String> _postsExercises = [];
  List<String> _namesToAddingThePost = [];
  List<String> _emailsToAddingThePost = [];
  List<String> _nameEmailCombined = [];
  String _nameEmailCombinedValue = "";
  bool get isProcessing => _isProcessing;
  bool get postToAddIsForAdmin => _postToAddIsForAdmin;
  int get registered => _registered;
  int get users => _users;
  int get addingPostExerciseScreen => _addingPostExerciseScreen;
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
  List<String> get postsExercises => _postsExercises;
  List<String> get namesToAddingThePost => _namesToAddingThePost;
  List<String> get emailsToAddingThePost => _emailsToAddingThePost;
  List<String> get nameEmailCombined => _nameEmailCombined;
  String get nameEmailCombinedValue => _nameEmailCombinedValue;

  /*
   * This is a very dirty haxx. I never recommend using it under any circumstances.
   * As we were having troubles for logging out from Firebase, I just thought
   * on a workaround and this is the best workaround I have found so far.
   */
  void clearVariables() {
    _isProcessing = false;
    _postToAddIsForAdmin = true;
    _registered = 0;
    _users = 0;
    _selectedScreen = 0;
    _addingPostExerciseScreen = 0;
    _user = null;
    _name = "";
    _str = "";
    _spinnerVal = "24H";
    _sender = [];
    _userInfo = [];
    _gymInfo = [];
    _gNames = [];
    uniqueSet = <String>{};
    _selectedWeekdays = [
      "Monday,",
      "Tuesday,",
      "Wednesday,",
      "Thursday,",
      "Friday,",
      "Saturday,",
      "Sunday,"
    ];
    _weekdays = "";
    _postsExercises = [];
    _namesToAddingThePost = [];
    _emailsToAddingThePost = [];
    _nameEmailCombined = [];
    _nameEmailCombinedValue = "";
  }

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
    final navigator = Navigator.of(context);
    processingAccState(0);
    await FirebaseAuth.instance.signOut();
    clearVariables();
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginRegister(),
      ),
          (route) => false,
    );
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
    await fbStore.collection("userinfo").doc(email).set({
      "name": name,
      "gender": gender,
      "email": email,
      "gymName": "",
      "admin": (email.contains("gym") || email.contains("admin")) ? true : false,
      "userPfp": "",
      "aboutMe": "",
    });
  }

  void modifyUserInfo({String name = "", String gender = "", String aboutMe = "", String userPfp = ""}) async {
    if(name.isNotEmpty && gender.isEmpty && aboutMe.isEmpty) {
      await fbStore.collection("userinfo").doc(auth.currentUser?.email).update({
        "name": name,
      });
      _userInfo.insert(0, name);
    } else if(gender.isNotEmpty && name.isEmpty && aboutMe.isEmpty) {
      await fbStore.collection("userinfo").doc(auth.currentUser?.email).update({
        "gender": gender,
      });
      _userInfo.insert(2, gender);
    } else if(aboutMe.isNotEmpty && name.isEmpty && gender.isEmpty) {
      await fbStore.collection("userinfo").doc(auth.currentUser?.email).update({
        "aboutMe": aboutMe,
      });
      _userInfo.insert(6, aboutMe);
    } else if(userPfp.isNotEmpty && name.isEmpty && gender.isEmpty && aboutMe.isEmpty) {
      await fbStore.collection("userinfo").doc(auth.currentUser?.email).update({
        "userPfp": userPfp,
      });
      _userInfo.insert(5, userPfp);
    } else if(name.isNotEmpty && gender.isNotEmpty && aboutMe.isNotEmpty && userPfp.isEmpty) {
      await fbStore.collection("userinfo").doc(auth.currentUser?.email).update({
        "name": name,
        "gender": gender,
        "aboutMe": aboutMe,
      });
      _userInfo.insert(0, name);
      _userInfo.insert(2, gender);
      _userInfo.insert(6, aboutMe);
    }
    notifyListeners();
  }

  getUserInfo() async {
    var doc = await fbStore.collection("userinfo").doc(auth.currentUser?.email).get();
    _userInfo.add(doc.data()!["name"]);
    _userInfo.add(doc.data()!["email"]);
    _userInfo.add(doc.data()!["gender"]);
    _userInfo.add(doc.data()!["gymName"]);
    _userInfo.add(doc.data()!["admin"].toString());
    _userInfo.add(doc.data()!["userPfp"]);
    _userInfo.add(doc.data()!["aboutMe"]);
    notifyListeners();
    return _userInfo;
  }

  addUserGymInfo(String gymName, {String email = "", bool isAdmin = false}) async {
    if(isAdmin && email.isNotEmpty) {
      await fbStore.collection("userinfo").doc(email).update ({
        "gymName": gymName
      });
    } else if(!isAdmin && email.isEmpty) {
      await fbStore.collection("userinfo").doc(auth.currentUser?.email).update ({
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
    await fbStore.collection("userinfo").doc(admin).update({
      "gymName": name,
    });

    fbStore.collection("gyminfo").doc(name).get().then((docSnapshot) => {
      exists = !docSnapshot.exists
    });

    if(!exists) {
      await fbStore.collection("gyminfo").doc(name).set({
        "name": name,
        "location": location,
        "admin": admin,
        "activeHours": activeHours,
        "price": price,
        "daysThatIsOpened": weekdays,
        "gymLogo": "",
      });
    }
  }

  getGymInfo(String str) async {
    if(_gymInfo.isNotEmpty) {
      _gymInfo = [];
    }
    var doc = await fbStore.collection("gyminfo").doc(str).get();
    _gymInfo.add(doc.data()!["name"]);
    _gymInfo.add(doc.data()!["location"]);
    _gymInfo.add(doc.data()!["activeHours"]);
    _gymInfo.add(doc.data()!["price"].toString());
    _gymInfo.add(doc.data()!["admin"]);
    _gymInfo.add(doc.data()!["daysThatIsOpened"]);
    _gymInfo.add(doc.data()!["gymLogo"]);
    notifyListeners();
    return _gymInfo;
  }

  uploadGymPFP(String str) async {
    await fbStore.collection("gyminfo").doc(_gymInfo[0]).update({
      "gymLogo": str,
    });
    _gymInfo.insert(6, str);
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
    QuerySnapshot<Map<String, dynamic>> query = await fbStore.collection("chat-${_userInfo[3]}").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = query.docs;
    for(QueryDocumentSnapshot<Map<String, dynamic>> element in documents) {
      sender.add(element.data()['sender']);
      sender.where((email) => uniqueSet.add(email)).toList();
      _users = uniqueSet.length;
    }
    notifyListeners();
  }

  getGyms() async {
    QuerySnapshot<Map<String, dynamic>> query = await fbStore.collection("gyminfo").get();
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
      fbStore.collection("chat-${_userInfo[3]}").doc("doc$index").update({
        "message": message,
        "modified": true,
      });
    } else {
      fbStore.collection("chat-${_userInfo[3]}").doc("doc$index").set({
        "sender": name,
        "senderMail": auth.currentUser!.email,
        "message": message,
        "timestamp": FieldValue.serverTimestamp(),
        "modified": false,
      });
    }
  }

  Stream<QuerySnapshot> getMessages() {
    Stream<QuerySnapshot> snapshots = fbStore.collection("chat-${_userInfo[3]}").orderBy("timestamp", descending: false).snapshots();
    getUsers();
    return snapshots;
  }

  changeScreen(int selected) {
    _selectedScreen = selected;
  }

  void setForAdmin() {
    _postToAddIsForAdmin = !_postToAddIsForAdmin;
    notifyListeners();
  }

  void setAddingPostExerciseScreen(int value) {
    _addingPostExerciseScreen = value;
    notifyListeners();
  }

  void addRemExercise(String str, {bool clear = false}) {
    if(_postsExercises.contains(str)) {
      _postsExercises.remove(str);
    } else {
      _postsExercises.add(str);
    }
    if(str == "" && clear) {
      _postsExercises = [];
    }
    notifyListeners();
  }

  Stream<QuerySnapshot> getPosts() {
    Stream<QuerySnapshot> snapshots = fbStore.collection("posts").orderBy("timestamp", descending: false).snapshots();
    return snapshots;
  }

  void sendPost(String exercises, String reps, String sets, {String pName = "", String pEmail = "", String content = "", String title = ""}) {
    String name, email;
    if(_userInfo[4] == "true") {
      if(postToAddIsForAdmin) {
        name = "${_userInfo[0]} (Trainer)";
        email = _userInfo[1];
      } else {
        name = pName;
        email = pEmail;
      }
    } else {
      name = _userInfo[0];
      email = _userInfo[1];
    }
    fbStore.collection("posts").add({
      "content": content,
      "exercises": exercises,
      "gymName": _userInfo[3],
      "name": name,
      "publisher": email,
      "reps": reps,
      "sets": sets,
      "timestamp": FieldValue.serverTimestamp(),
      "title": title,
      "uploadedByAdmin": (_userInfo[4] == "true") ? "true" : "false",
    });
  }

  Future<void> obtainValuesForPublishingPostToTheUser() async {
    QuerySnapshot<Map<String, dynamic>> query = await fbStore.collection("userinfo").where('gymName', isEqualTo: _userInfo[3]).get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = query.docs;
    for(QueryDocumentSnapshot<Map<String, dynamic>> element in documents) {
      if(element['name'] == _userInfo[0] && element['email'] == _userInfo[1]) {
        continue;
      }
      if(!_namesToAddingThePost.contains(element['name']) && !_emailsToAddingThePost.contains(element['email'])) {
        _namesToAddingThePost.add(element['name']);
        _emailsToAddingThePost.add(element['email']);
      }
    }
    _nameEmailCombined = List.generate(_namesToAddingThePost.length, (index) => '${_namesToAddingThePost[index]} - ${_emailsToAddingThePost[index]}');
    _nameEmailCombinedValue = _nameEmailCombined[0];
    notifyListeners();
  }

  void modifySelectedEmail(String email) {
    _nameEmailCombinedValue = email;
    notifyListeners();
  }

  void addClass(String collectionName, String hour, String limit, String name) async {
    await fbStore.collection("class-${_userInfo[3]}").doc(collectionName).set({
      "hour": hour,
      "limit": limit,
      "name": name,
      "users": []
    });
  }

  Stream<QuerySnapshot> getMyClasses() {
    Stream<QuerySnapshot> snapshots = fbStore.collection("class-${_userInfo[3]}").where("users", arrayContains: _userInfo[1]).snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot> getClasses() {
    Stream<QuerySnapshot> snapshots = fbStore.collection("class-${_userInfo[3]}").orderBy("hour", descending: false).snapshots();
    return snapshots;
  }

  void bookClass(docId, bool add) async {
    await fbStore.collection("class-${_userInfo[3]}").doc(docId).update ({
      "users": add ? FieldValue.arrayUnion([_userInfo[1]]) : FieldValue.arrayRemove([_userInfo[1]]),
    });
  }

  Stream<QuerySnapshot> getMyGymInfo() {
    Stream<QuerySnapshot> snapshots = fbStore.collection("gyminfo").where("name", isEqualTo: _userInfo[3]).snapshots();
    return snapshots;
  }

  void sendMyBenchmarks(String exercises, String reps, String sets, String previousReps, String previousSets) {
    fbStore.collection("benchmark-user_${_userInfo[1]}").add({
      "exercises": exercises,
      "previous_reps": previousReps,
      "previous_sets": previousSets,
      "reps": reps,
      "sets": sets,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getBenchmarks() {
    Stream<QuerySnapshot> snapshots = fbStore.collection("benchmark-user_${_userInfo[1]}").orderBy("timestamp", descending: false).snapshots();
    return snapshots;
  }
}
