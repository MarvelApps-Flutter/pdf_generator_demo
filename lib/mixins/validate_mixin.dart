mixin InputValidationMixin {
  bool isEmailValid(String email) {
    final RegExp regex = RegExp(r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return regex.hasMatch(email);
  }

  bool isPhoneNumberValid(String number) {
    final RegExp regex = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');

    return regex.hasMatch(number);
  }

  bool isGstinValid(String gstin) {
    final RegExp regex = RegExp(r'(^([0][1-9]|[1-2][0-9]|[3][0-7])([a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9a-zA-Z]{1}[zZ]{1}[0-9a-zA-Z]{1})+$)');

    return regex.hasMatch(gstin);
  }
}