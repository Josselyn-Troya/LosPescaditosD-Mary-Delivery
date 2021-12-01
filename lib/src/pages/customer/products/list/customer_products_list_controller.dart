import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProductsListController {
  BuildContext context;
  ShraredPrefe _shraredPrefe = new ShraredPrefe();

  Future init(BuildContext context){
    this.context = context;
  }

  logout(){
    _shraredPrefe.logout(context);
  }

}