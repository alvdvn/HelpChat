import 'package:flutter/cupertino.dart';

import 'login_model.dart';

class LoginViewModel extends ChangeNotifier {
  var _formData = const LoginModel();
  var _validateMode = AutovalidateMode.disabled;

  AutovalidateMode get validateMode => _validateMode;

  LoginModel get formData => _formData;

  void updateForm({String? username, String? password}) {
    _formData = _formData.copyWith(username: username, password: password);
    notifyListeners();
  }

  set validateMode(AutovalidateMode value) {
    _validateMode = value;
    notifyListeners();
  }
}
