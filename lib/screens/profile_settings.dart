import 'package:fitlife/models/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final _nameTextController = TextEditingController();
  final _aboutMeTextController = TextEditingController();
  String gender = "";
  List<Widget> icons = <Widget>[
    const Icon(Icons.male),
    const Icon(Icons.female),
  ];
  final List<String> _genders = <String>["Masculino", "Femenino"];
  late List<bool> selectedGenderValues;

  @override
  void initState() {
    super.initState();
    var model = context.read<Model>();
    _nameTextController.text = model.userInfo[0];
    gender = model.userInfo[2];
    selectedGenderValues = _genders.map((g) => g == gender).toList();
    _aboutMeTextController.text = model.userInfo[6];
  }

  @override
  Widget build(BuildContext context) {
    var model = context.read<Model>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if(_nameTextController.text != model.userInfo[0] && gender == model.userInfo[2] && _aboutMeTextController.text == model.userInfo[6]) {
                model.modifyUserInfo(name: _nameTextController.text);
                model.showSnackbar(context, "Name was updated succesfully", color: Colors.green);
              } else if(_nameTextController.text == model.userInfo[0] && gender != model.userInfo[2] && _aboutMeTextController.text == model.userInfo[6]) {
                model.modifyUserInfo(gender: gender);
                model.showSnackbar(context, "Gender was updated succesfully", color: Colors.green);
              } else if(_nameTextController.text == model.userInfo[0] && gender == model.userInfo[2] && _aboutMeTextController.text != model.userInfo[6]) {
                model.modifyUserInfo(aboutMe: _aboutMeTextController.text);
                model.showSnackbar(context, "About me was updated succesfully", color: Colors.green);
              } else if(_nameTextController.text != model.userInfo[0] && gender != model.userInfo[2] && _aboutMeTextController.text != model.userInfo[6]) {
                model.modifyUserInfo(name: _nameTextController.text, gender: gender, aboutMe: _aboutMeTextController.text);
                model.showSnackbar(context, "Every field were updated succesfully", color: Colors.green);
              }
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _nameTextController,
              decoration: InputDecoration(
                hintText: "Name",
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          ToggleButtons(
            onPressed: (int index) {
              setState(() {
                selectedGenderValues = List.generate(_genders.length, (i) => i == index); // update the list
                gender = _genders[index]; // update the selected gender
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.green[700],
            selectedColor: Colors.white,
            fillColor: Colors.green[200],
            color: Colors.green[400],
            isSelected: selectedGenderValues,
            children: icons,
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _aboutMeTextController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "About Me",
                labelText: "About Me",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
