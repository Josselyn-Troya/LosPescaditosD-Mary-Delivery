import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';

class CustomerProductsListController {
  BuildContext context;
  ShraredPrefe _shraredPrefe = new ShraredPrefe();

  Function refresh;
 
  User user;

  Future init(BuildContext context, Function refresh) async{
    this.context = context; 
    this.refresh = refresh;
    user = User.fromJson(await _shraredPrefe.read('user'));
    refresh();
  }

  void logout(){
    _shraredPrefe.logout(context, user.id);
  }

  void goToUpdatePage(){
    Navigator.pushNamed(context, 'customer/update');
  }

  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

}