import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/models/category.dart';
import 'package:lospescaditosdmary/src/models/product.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/pages/customer/products/detail/customer_products_detail_page.dart';
import 'package:lospescaditosdmary/src/provider/categories_provider.dart';
import 'package:lospescaditosdmary/src/provider/products_provider.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CustomerProductsListController {
  BuildContext context;
  ShraredPrefe _shraredPrefe = new ShraredPrefe();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Function refresh;
 
  User user;
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  ProductsProvider _productsProvider = new ProductsProvider();
  List<Category> categories = [];

  Future init(BuildContext context, Function refresh) async{
    this.context = context; 
    this.refresh = refresh;
    user = User.fromJson(await _shraredPrefe.read('user'));
    _categoriesProvider.init(context, user);
    _productsProvider.init(context, user);
    getCategories();
    refresh();
  }

  Future<List<Product>> getProducts(String idCategory) async {
    
      return await _productsProvider.getByCategory(idCategory);
    
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
}