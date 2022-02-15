import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lospescaditosdmary/src/models/category.dart';
import 'package:lospescaditosdmary/src/models/product.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/pages/customer/products/detail/customer_products_detail_page.dart';
import 'package:lospescaditosdmary/src/provider/categories_provider.dart';
import 'package:lospescaditosdmary/src/provider/notification_provider.dart';
import 'package:lospescaditosdmary/src/provider/products_provider.dart';
import 'package:lospescaditosdmary/src/provider/users_provider.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CustomerProductsListController {
  BuildContext context;
  SharedPrefe _sharedPrefe = new SharedPrefe();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Function refresh;
 
  User user;
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  ProductsProvider _productsProvider = new ProductsProvider();
  List<Category> categories = [];

  Timer searchOnStopped;
  String productName = '';


  Future init(BuildContext context, Function refresh, Product product) async{
    this.context = context; 
    this.refresh = refresh;
    user = User.fromJson(await _sharedPrefe.read('user'));
    _categoriesProvider.init(context, user);
    _productsProvider.init(context, user);


    getCategories();



    refresh();
  }


  void searchText(String text) {
    Duration duration = Duration(microseconds: 200);
    if(searchOnStopped != null){
      searchOnStopped.cancel();
      refresh();
    }
    searchOnStopped = new Timer(duration, () {
      productName = text;
      refresh();
    });
  }

  Future<List<Product>> getProducts(String idCategory, String productName) async {
    if(productName.isEmpty){
      return await _productsProvider.getByCategory(idCategory);

    }else{
      return await _productsProvider.getByCategoryProduct(idCategory, productName);

    }

  }


  void logout(){
    _sharedPrefe.logout(context, user.id);
  }

  void goToUpdatePage(){
    Navigator.pushNamed(context, 'customer/update');
  }

   void goToOrderCreatePage(){
    Navigator.pushNamed(context, 'customer/orders/create');
  }

  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void getCategories() async{
    categories = await _categoriesProvider.getAll();
    refresh();
  }

  void openBottomSheet(Product product) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => CustomerProductsDetailPage(product: product)
    );
  }


  void goToOrdersList(){
    Navigator.pushNamed(context, 'customer/orders/list');
  }


}