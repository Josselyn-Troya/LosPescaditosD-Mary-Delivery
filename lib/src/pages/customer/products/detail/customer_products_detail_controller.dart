import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lospescaditosdmary/src/models/product.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';

class CustomerProductsDetailController {
  
  BuildContext context;
  Function refresh;

  Product product;

  int counter = 1;
  double productPrice;

  SharedPrefe _sharedPrefe = new SharedPrefe();

  List<Product> selectedProducts = [];

  Future init(BuildContext  context, Function refresh, Product product) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product.price;

    //_SharedPrefe.remove('order');

    selectedProducts = Product.fromJsonList(await _sharedPrefe.read('order')).toList;

    selectedProducts.forEach((p) {
      print('Producto seleccionado: ${p.toJson()}');
    });
    refresh();
  }

  void addToCar(){
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    if(index == -1 ){ //si en los productos selecionados no existe ese producto
      if(product.quantity == null){
        product.quantity = 1;
      }

      selectedProducts.add(product);
    }else{
      selectedProducts[index].quantity=counter;
    }
    _sharedPrefe.save('order', selectedProducts);
    Fluttertoast.showToast(msg: 'Producto agregado');
  }

  void addItem(){
    counter = counter + 1;
    productPrice = product.price * counter;
    product.quantity = counter;
    refresh();
  }

  void removeItem(){
    if (counter > 1) {
      counter = counter - 1;
      productPrice = product.price * counter;
      product.quantity = counter;
      refresh();
    }
   
  }
}