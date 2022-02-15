import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/models/category.dart';
import 'package:lospescaditosdmary/src/models/response_api.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/provider/categories_provider.dart';
import 'package:lospescaditosdmary/src/utils/my_validations.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';


class AdminCategoriesCreateController {

  BuildContext context;
  Function refresh;

  TextEditingController nameController = new TextEditingController();

  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  User user;
  SharedPrefe sharedPrefe = new SharedPrefe();


  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPrefe.read('user'));
    _categoriesProvider.init(context, user);
  }

  void createCategory() async {
    String name = nameController.text;

    if (name.isEmpty ) {
      MyValidations.show(context, 'Debe llenar todos los campos');
      return;
    }else{
      nameController.text = '';
    }

    Category category = new Category(
      name: name,
    );

    ResponseApi responseApi = await _categoriesProvider.create(category);
    
    MyValidations.show(context, responseApi.message);
    
    
  }

}
