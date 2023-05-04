import 'package:flutter/cupertino.dart';

import 'signup_model.dart';

class SignUpViewModel extends ChangeNotifier {
  var _formData = const SignUpModel(isAdmin: false);
  var _validateMode = AutovalidateMode.disabled;

  AutovalidateMode get validateMode => _validateMode;

  SignUpModel get formData => _formData;

  void updateForm({
    String? name,
    String? email,
    String? password,
    bool? isAdmin,
  }) {
    _formData = _formData.copyWith(
        name: name, email: email, password: password, isAdmin: isAdmin);
    notifyListeners();
  }

  set validateMode(AutovalidateMode value) {
    _validateMode = value;
    notifyListeners();
  }
}
