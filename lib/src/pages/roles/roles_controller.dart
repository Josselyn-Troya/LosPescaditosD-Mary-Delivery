import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RolesController {

  BuildContext context;
  Function refresh;
  User user;
  ShraredPrefe shraredPrefe = new ShraredPrefe();

  
  Future init (BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    //obtiene el usuario de inicio de session
    user = User.fromJson( await shraredPrefe.read('user'));
    refresh();
  }


  void goToPage (String route){
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}