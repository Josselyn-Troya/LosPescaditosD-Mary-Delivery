import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';

class RolesController {

  BuildContext context;
  Function refresh;
  User user;
  SharedPrefe _sharedPrefe = new SharedPrefe();

  
  Future init (BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    //obtiene el usuario de inicio de session
    user = User.fromJson( await _sharedPrefe.read('user'));
    refresh();
  }


  void goToPage (String route){
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}