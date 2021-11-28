import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/models/response_api.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/provider/users_provider.dart';
import 'package:lospescaditosdmary/src/utils/my_validations.dart';

class RegisterController {
  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();

  Future init(BuildContext context){
    this.context = context;
    usersProvider.init(context);
  }

  void register () async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if(email.isEmpty || name.isEmpty || lastname.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty){
      MyValidations.show(context, 'Debes completar todos los campos');
      
      return;
    }

    if(confirmPassword != password){
      MyValidations.show(context, 'Las contraseñas no son iguales');
      return;
    }

    if(password.length <6 ){
      MyValidations.show(context, 'La contraseña debe tener al menos 6 caracteres');
      return;
    }

    User user = new User(
      email: email,
      name: name,
      lastname: lastname,
      phone: phone,
      password: password
    );

    ResponseApi responseApi = await usersProvider.create(user);

    MyValidations.show(context, responseApi.message);

    print('respuesta: ${responseApi.toJson()}');

    print(email);
    print(name);
    print(lastname);
    print(phone);
    print(password);
    print(confirmPassword);
  }
}