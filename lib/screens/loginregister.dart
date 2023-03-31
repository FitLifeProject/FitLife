import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife/models/model.dart';
import 'package:fitlife/resources/validator.dart';
import 'package:fitlife/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _gymNameTextController = TextEditingController();
  final _gymLocationController = TextEditingController();
  final _activeHoursController = TextEditingController();
  final _priceController = TextEditingController();
  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  String gender = "";
  String _selectedHour = "24H";
  final List<String> _hoursOptions = [
    "24H",
    "12H",
    "8H",
    "6H"
  ];
  List<Widget> icons = <Widget>[
    const Icon(Icons.male),
    const Icon(Icons.female),
  ];
  List<bool> _selectedGender = <bool>[false, true];
  final List<String> _genders = <String>["Masculino", "Femenino"];

  @override
  initState() {
    super.initState();
  }

  Widget _buildWeekdayButton(model, String weekday, int i) {
    bool isSelected = model.selectedWeekdays.contains(weekday);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          model.manageDays(isSelected, weekday, i);
        });
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.background,
      ),
      child: Text(
        weekday.substring(0,1),
        style: TextStyle(
          color: isSelected ? Colors.black : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    final form = _formKey.currentState;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(53, 104, 89, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
              child: Text(
            "FITLIFE",
            style: GoogleFonts.russoOne(
                textStyle: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 5)),
          )),
          const SizedBox(height: 16.0),
          if (model.registered == 1) ...[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailTextController,
                    focusNode: _focusEmail,
                    validator: (value) => Validator.validateEmail(
                      email: value,
                    ),
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordTextController,
                    focusNode: _focusPassword,
                    obscureText: true,
                    validator: (value) => Validator.validatePassword(
                      password: value,
                      register: false,
                    ),
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BackButton(
                  color: Colors.white,
                  onPressed: () {
                    model.processingAccState(0);
                    _emailTextController.text = "";
                    _passwordTextController.text = "";
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    _focusName.unfocus();
                    _focusEmail.unfocus();
                    _focusPassword.unfocus();

                    if (form != null && form.validate()) {
                      model.processingData(true);
                    }

                    User? user = await model.signIn(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                      context: context,
                    );

                    model.processingData(false);

                    if (user != null) {
                      _emailTextController.text = "";
                      _passwordTextController.text = "";
                      navigator.push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const Home();
                          },
                        ),
                      );
                      model.getUserInfo();
                      user = null;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(47, 203, 66, 1),
                    minimumSize: const Size(125, 50),
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            TextButton(
              child: const Text("Don't you remember your password?"),
              onPressed: () {
                model.processingAccState(4);
              },
            )
          ] else if (model.registered == 2) ...[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameTextController,
                    focusNode: _focusName,
                    decoration: InputDecoration(
                      hintText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailTextController,
                    focusNode: _focusEmail,
                    validator: (value) => Validator.validateEmail(
                      email: value,
                    ),
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordTextController,
                    focusNode: _focusPassword,
                    obscureText: true,
                    validator: (value) => Validator.validatePassword(
                      password: value,
                      register: false,
                    ),
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  ToggleButtons(
                    onPressed: (int index) {
                      _selectedGender = model.updateToggleButton(_selectedGender, index, _genders);
                      gender = model.str;
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: Colors.green[700],
                    selectedColor: Colors.white,
                    fillColor: Colors.green[200],
                    color: Colors.green[400],
                    isSelected: _selectedGender,
                    children: icons,
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BackButton(
                  color: Colors.white,
                  onPressed: () {
                    model.processingAccState(0);
                    _nameTextController.text = "";
                    _emailTextController.text = "";
                    _passwordTextController.text = "";
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    model.processingData(true);

                    if(form != null && form.validate()) {
                      User? user = await model.register(
                          name: _nameTextController.text,
                          email: _emailTextController.text,
                          password: _passwordTextController.text,
                          context: context,
                      );
                      model.processingData(false);

                      if(user != null) {
                        if(_emailTextController.text.contains("gym") || _emailTextController.text.contains("admin")) {
                          model.processingAccState(3);
                        }
                        model.addUserInfo(
                          _nameTextController.text,
                          _emailTextController.text,
                          gender,
                        );

                        if(model.registered == 2) {
                          _nameTextController.text = "";
                          _emailTextController.text = "";
                          _passwordTextController.text = "";
                          navigator.push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const Home();
                              },
                            ),
                          );
                          model.getUserInfo();
                          user = null;
                        }
                      }
                    } else {
                      model.processingData(false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(64, 151, 117, 1),
                    minimumSize: const Size(125, 50),
                  ),
                  child: Text(
                    model.registered == 3 ? "Add gym info" : 'Sign up',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ] else if(model.registered == 3) ...[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _gymNameTextController,
                    decoration: InputDecoration(
                      hintText: "Gym Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _gymLocationController,
                    decoration: InputDecoration(
                      hintText: "Location (Ex: 3609 Driftwood Road, Portland)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 35,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildWeekdayButton(model, "Sunday,", 6),
                        const SizedBox(width: 2.0),
                        _buildWeekdayButton(model, "Monday,", 0),
                        const SizedBox(width: 2.0),
                        _buildWeekdayButton(model, "Tuesday,", 1),
                        const SizedBox(width: 2.0),
                        _buildWeekdayButton(model, "Wednesday,", 2),
                        const SizedBox(width: 2.0),
                        _buildWeekdayButton(model, "Thursday,", 3),
                        const SizedBox(width: 2.0),
                        _buildWeekdayButton(model, "Friday,", 4),
                        const SizedBox(width: 2.0),
                        _buildWeekdayButton(model, "Saturday,", 5)
                      ],
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: DropdownButton<String>(
                        value: _selectedHour,
                        items: _hoursOptions.map((color) {
                          return DropdownMenuItem<String>(
                            value: color,
                            child: Text(color),
                          );
                        }).toList(),
                        onChanged: (newHour) {
                          _selectedHour = newHour!;
                          model.changeSpinnerValue(newHour);
                        },
                        iconEnabledColor: Colors.white,
                        underline: Container(),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Visibility(
                    visible: _selectedHour != "24H",
                    child: TextFormField(
                      controller: _activeHoursController,
                      decoration: InputDecoration(
                        hintText: "Ex: 10:00-3:00AM 5:00-10:00PM",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: _priceController,
                    validator: (value) => Validator.validateNumber(
                      number: _priceController.text,
                    ),
                    decoration: InputDecoration(
                      hintText: "Price",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BackButton(
                  color: Colors.white,
                  onPressed: () {
                    model.processingAccState(0);
                    _nameTextController.text = "";
                    _emailTextController.text = "";
                    _passwordTextController.text = "";
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    model.processingData(true);

                    if(form != null && form.validate()) {
                      model.processingData(false);

                      model.addGymInfo(
                          _gymNameTextController.text,
                          _gymLocationController.text,
                          _emailTextController.text,
                          (_activeHoursController.text.isEmpty) ? _selectedHour : _activeHoursController.text,
                          double.parse(_priceController.text),
                          (model.weekdays.isEmpty) ? "Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday," : model.weekdays,
                      );

                      _nameTextController.text = "";
                      _emailTextController.text = "";
                      _passwordTextController.text = "";
                      _gymNameTextController.text = "";
                      _gymLocationController.text = "";
                      _activeHoursController.text = "";
                      _priceController.text = "";

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const Home();
                          },
                        ),
                      );
                    } else {
                      model.processingData(false);
                    }
                    model.getUserInfo();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(64, 151, 117, 1),
                    minimumSize: const Size(125, 50),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ] else if(model.registered == 4)...[
            Form(
              key: _formKey,
              child: Column(
                  children: [
                    TextFormField(
                      controller: _emailTextController,
                      focusNode: _focusEmail,
                      validator: (value) => Validator.validateEmail(
                        email: value,
                      ),
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BackButton(
                  color: Colors.white,
                  onPressed: () {
                    model.processingAccState(0);
                    _emailTextController.text = "";
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    model.resetPassword(email: _emailTextController.text);
                    model.processingAccState(0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(47, 203, 66, 1),
                    minimumSize: const Size(125, 50),
                  ),
                  child: const Text(
                    'Recover password',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ] else ...[
            ElevatedButton(
              onPressed: () async {
                model.processingAccState(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(47, 203, 66, 1),
                minimumSize: const Size(125, 50),
              ),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                model.processingAccState(2);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(64, 151, 117, 1),
                minimumSize: const Size(125, 50),
              ),
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ]),
      ),
    );
  }
}
