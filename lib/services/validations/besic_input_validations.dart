import 'validation_strings.dart';

ErrorStrings _errorAppStrings = ErrorStrings();

class InputValidations {
  // [ Name ]
  static dynamic name(String name) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(patttern);
    if (whiteSpaceCheck(name)) {
      return _errorAppStrings.pleaseEnterYourName;
    } else if (name.length < 3) {
      return _errorAppStrings.yourNameMustBeAbove3Characters;
    } else if (!regExp.hasMatch(name)) {
      return _errorAppStrings.yourNameMustBeAtoZ;
    }
  }

  // [ First Name ]
  static dynamic firstName(String name) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(patttern);
    if (whiteSpaceCheck(name)) {
      return _errorAppStrings.pleaseEnterYourFirstName;
    } else if (name.length < 3) {
      return _errorAppStrings.yourFirstNameMustBeAbove3Characters;
    } else if (!regExp.hasMatch(name)) {
      return _errorAppStrings.yourFirstNameMustBeAtoZ;
    }
  }

  // [ Last Name ]
  static dynamic lastName(String name) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(patttern);
    if (whiteSpaceCheck(name)) {
      return _errorAppStrings.pleaseEnterYourLastName;
    } else if (name.length < 3) {
      return _errorAppStrings.yourLastNameMustBeAbove3Characters;
    } else if (!regExp.hasMatch(name)) {
      return _errorAppStrings.yourLastNameMustBeAtoZ;
    }
  }

  // [ Email ]

  static dynamic email(String? email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    if (whiteSpaceCheck(email!)) {
      return _errorAppStrings.pleaseEnterYourEmail;
    } else if (!regExp.hasMatch(email)) {
      return _errorAppStrings.pleaseEnterValidEmail;
    } else {
      return null;
    }
  }

  // [Mobile]

  static dynamic mobile(String mobile) {
    if (whiteSpaceCheck(mobile)) {
      return _errorAppStrings.pleaseEnterYourMobileNumber;
    } else if (mobile.length < 10) {
      return _errorAppStrings.pleasevalidMobileNumber;
    } else {
      return null;
    }
  }

  // [Phone]

  static dynamic phone(String phone) {
    if (whiteSpaceCheck(phone)) {
      return _errorAppStrings.pleaseEnterYourPhoneNumber;
    } else if (phone.length < 10) {
      return _errorAppStrings.pleasevalidPhoneNumber;
    } else {
      return null;
    }
  }

  // [loaction]

  static dynamic loaction(String? location) {
    if (whiteSpaceCheck(location!)) {
      return _errorAppStrings.pleaseEnterYourLocation;
    } else {
      return null;
    }
  }

  // [account holder name]

  static dynamic accountHolderNumber(String? name) {
    if (whiteSpaceCheck(name!)) {
      return _errorAppStrings.pleaseEnterAccountHolderName;
    } else {
      return null;
    }
  }

  // [account number]

  static dynamic accountNumber(String? number) {
    if (whiteSpaceCheck(number!)) {
      return _errorAppStrings.pleaseEnterYourAccountNumber;
    } else {
      return null;
    }
  }

  // [ifsc code]

  static dynamic ifscCode(String? code) {
    if (whiteSpaceCheck(code!)) {
      return _errorAppStrings.pleaseEnterYourIfscCode;
    } else {
      return null;
    }
  }

  // [cpr/license]

  static dynamic cprLicense(String? code) {
    if (whiteSpaceCheck(code!)) {
      return _errorAppStrings.pleaseEnterYourCprLicense;
    } else {
      return null;
    }
  }

  // [address]

  static dynamic address(String? text) {
    if (whiteSpaceCheck(text!)) {
      return _errorAppStrings.thisFieldIsRequired;
    }
    if (text.length < 2) {
      return _errorAppStrings.pleaseEnterValidadress;
    } else {
      return null;
    }
  }

  // [title]

  static dynamic title(String? text) {
    if (whiteSpaceCheck(text!)) {
      return _errorAppStrings.thisFieldIsRequired;
    }
    if (text.length < 2) {
      return _errorAppStrings.pleaseEnterValidTitle;
    } else {
      return null;
    }
  }

  // [empty]

  static dynamic required(String? text) {
    if (whiteSpaceCheck(text!)) {
      return _errorAppStrings.thisFieldIsRequired;
    } else {
      return null;
    }
  }
}

// [for check all type fo white space]
bool whiteSpaceCheck(String text) {
  if (text == "" ||
      text == " " * text.length ||
      text ==
          '''

''' *
              text.length) {
    return true;
  } else {
    return false;
  }
}
