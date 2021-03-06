import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/models/response_api.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/provider/notification_provider.dart';
import 'package:lospescaditosdmary/src/provider/users_provider.dart';
import 'package:lospescaditosdmary/src/utils/my_validations.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';

class LoginController {

  BuildContext context;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();

  NotificationProvider notificationProvider = new NotificationProvider();

  SharedPrefe _sharedPrefe = new SharedPrefe();

  //proceso que tarda tiempo 
  Future init(BuildContext context) async {
    this.context = context;
    await usersProvider.init(context);

    User user = User.fromJson(await _sharedPrefe.read('user') ?? {});

    print('usario: ${user.toJson()}');

    if(user !=null){
      if(user?.sessionToken != null){

        notificationProvider.saveToken(user, context);

       if (user.roles.length > 1) {
         print('usuario en roles');
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      }else {
        Navigator.pushNamedAndRemoveUntil(context, user.roles[0].route, (route) => false);
      }
      }
    }
    
  }

  void registerPage(){
    Navigator.pushNamed(context, 'register');
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    ResponseApi responseApi = await usersProvider.login(email, password);

    
    print('respuesta: ${responseApi.toJson()}');


    if (responseApi.success){
      User user = User.fromJson(responseApi.data);
      _sharedPrefe.save('user', user.toJson());
      
      notificationProvider.saveToken(user, context);

      print('usuario logedo: ${user.toJson()}');

       if (user.roles.length > 1) {
         print('usuario en roles');
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      }else {
        Navigator.pushNamedAndRemoveUntil(context, user.roles[0].route, (route) => false);
      }

      //nos lleva a la siguiente pantalla elminando el 
      //historial de las pantallas anteriores
      /* Navigator.pushNamedAndRemoveUntil(context, 'customer/products/list', (route) => false); */
      
    }else{
      MyValidations .show(context, responseApi.message);
    }


   
    print('respuesta: ${responseApi.toJson()}');
   

  }


}