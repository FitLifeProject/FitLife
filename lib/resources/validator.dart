/*
 * Copyright (C) 2023 JMPFBMX
 */
class Validator {
  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Name can\'t be empty';
    } else if (name.length < 3) {
      return 'Name must have more than 3 characters';
    }

    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(r"^\S+@\S+\.\S+$");

    if (email.isEmpty) {
      return "Email can't be empty";
    } else if (!emailRegExp.hasMatch(email)) {
      return "Enter a valid email address";
    }

    return null;
  }

  static String? validatePassword({required String? password, required bool register}) {
    if (password == null) {
      return null;
    }
    if(register) {
      /*
       * Password Regex:
       *  - (?=.*[A-Z]): should contain at least one upper case.
       *  - (?=.*[a-z]): should contain at least one lower case.
       *  - (?=.*?[0-9]): should contain at least one digit.
       *  - (?=.*?[!@#\$&*~]): should contain at least one Special character.
       *  - .{8,}: Must be at least 8 characters in length.
       */
      RegExp passwdRegExp =
      RegExp(r"^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[\d])(?=.*?[!@#\$&*~_]).{8,}$");
      if (!passwdRegExp.hasMatch(password)) {
        return "Password should contain at least:\n - 1 upper and lower case\n - 1 digit\n - 1 special character\n and must have at least 8 characters";
      }
    }
    if (password.isEmpty) {
      return "Password can't be empty";
    }

    return null;
  }
  
  static String? validateNumber({required String? number}) {
    if(number == null) {
      return null;
    }
    
    if(number.isEmpty) {
      return "How is your gym free?";
    } else if(number.contains(RegExp(r"^(?=.*?[a-z])(?=.*?[A-Z])"))) {
      return "Price can just contains numbers (decimals are separated by a dot)";
    }
    
    return null;
  }
}
