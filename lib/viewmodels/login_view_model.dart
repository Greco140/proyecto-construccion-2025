import 'package:dynadoc_front/models/user.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool _inRegistrationState = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passConfirmController = TextEditingController();
  bool _isCreatorSelected = false;

  Future<bool> login() async {
    bool isFormValid = _formKey.currentState!.validate();
    if (isFormValid) {
      User user = User(email: _emailController.text);
      bool success = await user.login(_passwordController.text);
      return success;
    }
    return false;
  }

  Future<bool> createAccount() async {
    bool isFormValid = _formKey.currentState!.validate();
    if (isFormValid) {
      User user = User(
        email: _emailController.text,
        name: _nameController.text,
        role: _isCreatorSelected ? "CREADOR" : "USUARIO",
      );

      bool success = await user.register(_passwordController.text);
      if (success) setRegistrationState(false);
      return success;
    }
    return false;
  }

  bool validateEmail(String? value) {
    if (value == null) return false;
    bool isEmailValid = EmailValidator.validate(value);
    return isEmailValid ? true : false;
  }

  bool validateText(String? value) {
    return (value == null || value.isEmpty) ? false : true;
  }

  bool confirmPassword(String? value) {
    return (value == _passwordController.text) ? true : false;
  }

  bool isInRegistrationState() {
    return _inRegistrationState;
  }

  void setRegistrationState(bool state) {
    //Se limpian los campos ya que los dos formularios comparten la misma llave
    //Con esto nos evitamos comportamiento no esperado
    _emailController.clear();
    _nameController.clear();
    _passwordController.clear();
    _passConfirmController.clear();
    _formKey.currentState!.reset();

    _inRegistrationState = state;
    notifyListeners();
  }

  GlobalKey<FormState> getFormKey() {
    return _formKey;
  }

  TextEditingController getEmailController() {
    return _emailController;
  }

  TextEditingController getNameController() {
    return _nameController;
  }

  TextEditingController getPasswordController() {
    return _passwordController;
  }

  TextEditingController getPassConfirmController() {
    return _passConfirmController;
  }

  void setIsCreatorSelected(bool isCreatorSelected) {
    _isCreatorSelected = isCreatorSelected;
  }
}
