import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lospescaditosdmary/src/models/response_api.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/provider/users_provider.dart';
import 'package:lospescaditosdmary/src/utils/my_validations.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';


class CustomerUpdateController {
  BuildContext context;
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
 

  UsersProvider usersProvider = new UsersProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;

  ProgressDialog _progressDialog;

  bool isEnable = true;
  User user;
  ShraredPrefe _shraredPrefe = new ShraredPrefe();



  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    usersProvider.init(context);
    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _shraredPrefe.read('user'));

    nameController.text = user.name;
    lastnameController.text = user.lastname;
    phoneController.text = user.phone;
    refresh();
  }

  void update () async {
    
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text.trim();
   
    if (name.isEmpty || lastname.isEmpty || phone.isEmpty){
      MyValidations.show(context, 'Debes completar todos los campos');
      
      return;
    }


    /* if(imageFile == null){
      MyValidations.show(context, 'Seleccione una imagen');
      return;
    } */

    _progressDialog.show(max: 100, msg: 'Cargando');
    isEnable = false;

    User myUser = new User(
      id: user.id,
      name: name,
      lastname: lastname,
      phone: phone,
    );

    Stream stream = await usersProvider.update(myUser, imageFile);
    stream.listen((res) async {

      _progressDialog.close();

      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      Fluttertoast.showToast(msg: responseApi.message);


      if (responseApi.success) {

        user = await usersProvider.getById(myUser.id); //obteniendo el usuario de la bd
        _shraredPrefe.save('user', user.toJson());
        Navigator.pushNamedAndRemoveUntil(context, 'customer/products/list', (route) => false);
      }
      else {
        isEnable = true;
      }

    });

    print(name);
    print(lastname);
    print(phone);
    
  }

  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
        },
        child: Text('GALERIA')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: Text('CAMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );
  }

  void back() {
    Navigator.pop(context);
  }
}