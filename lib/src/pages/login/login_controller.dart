import 'package:flutter/material.dart';

class LoginController {

  BuildContext context;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Future init(BuildContext context) {
    this.context = context;
  }


  void registerPage(){
    Navigator.pushNamed(context, 'register');
  }

  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();


  }


}