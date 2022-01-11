import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/provider/users_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefe {

  //metodo para guardar información
  void save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  //metodo para leer la informacion almacenada
  //Future = porque puede tradar algo de tiempo
  Future<dynamic> read(String key) async  {
    final prefs = await SharedPreferences.getInstance();  
  
    if(prefs.getString(key) == null) return null;

    return json.decode(prefs.getString(key));
  }

  //si existe en el sharedPreferens algun dato
  Future<bool> constrains(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);

  }


  //eliminar un dato de sharedPreferens
  Future<bool> remove(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);

  }


  void logout(BuildContext context, String idUser) async {
    UsersProvider usersProvider = new UsersProvider();
    usersProvider.init(context);
    await usersProvider.logout(idUser);
    await remove('user');
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }
}
