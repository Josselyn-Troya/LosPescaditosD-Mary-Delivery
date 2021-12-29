import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lospescaditosdmary/src/models/category.dart';
import 'package:lospescaditosdmary/src/models/product.dart';
import 'package:lospescaditosdmary/src/models/response_api.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/provider/categories_provider.dart';
import 'package:lospescaditosdmary/src/provider/products_provider.dart';
import 'package:lospescaditosdmary/src/utils/my_validations.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';


class AdminProductsCreateController {

  BuildContext context;
  Function refresh;

  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  MoneyMaskedTextController priceController = new MoneyMaskedTextController();
  
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  ProductsProvider _productsProvider = new ProductsProvider();
  User user;
  ShraredPrefe sharedPrefe = new ShraredPrefe();

  List<Category> categories = [];
  String idCategory; //almacena el id de la categoria seleccionada

  //image
  PickedFile pickedFile;
  File imageFile1;
  File imageFile2;

  ProgressDialog _progressDialog;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _progressDialog = new ProgressDialog(context: context);
    user = User.fromJson(await sharedPrefe.read('user'));
    _categoriesProvider.init(context, user);
    _productsProvider.init(context, user);
    getCategories();
  }


  void getCategories() async{
    categories = await _categoriesProvider.getAll();
    refresh();
  }

  void createProduct() async {
    String name = nameController.text;
    String description = descriptionController.text;
    double price = priceController.numberValue;

    if (name.isEmpty || description.isEmpty || price == 0) {
      MyValidations.show(context, 'Debe llenar todos los campos');
      return;
    }
    /* if(imageFile1 == null || imageFile2 == null ){
      MyValidations.show(context, 'Debe ingresar una imagen');
      return;
    } */
    if(idCategory == null){
      MyValidations.show(context, 'Debe seleccionar la categoria del producto');
      return;
    }


    Product product = new Product(
      name: name,
      description: description,
      price: price,
      idCategory: int.parse(idCategory)
    );

     List<File> images = [];
    images.add(imageFile1);
    images.add(imageFile2);

    _progressDialog.show(max: 100, msg: 'Espere un momento');

    Stream stream = await _productsProvider.create(product, images);
    stream.listen((res) {
        _progressDialog.close();

        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        MyValidations.show(context, responseApi.message);

        if (responseApi.success) {
          resetValues();
        }
    });

    print('Producto del formulario: ${product.toJson()}');

  }

  void resetValues() {
    nameController.text = '';
    descriptionController.text = '';
    priceController.text = '0.0';
    imageFile1 = null;
    imageFile2 = null;
    idCategory = null;
    refresh();
  }

  //image
  //
  Future selectImage(ImageSource imageSource, int numberFile) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {

      if(numberFile == 1){
        imageFile1 = File(pickedFile.path);
      }else if(numberFile == 2){
        imageFile2 = File(pickedFile.path);
      }  

    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog(int numberFile) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery, numberFile);
        },
        child: Text('GALERIA')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera, numberFile);
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

}
