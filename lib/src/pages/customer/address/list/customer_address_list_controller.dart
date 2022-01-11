import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/models/address.dart';
import 'package:lospescaditosdmary/src/models/order.dart';
import 'package:lospescaditosdmary/src/models/product.dart';
import 'package:lospescaditosdmary/src/models/response_api.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/provider/address_provider.dart';
import 'package:lospescaditosdmary/src/provider/orders_provider.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';

class  CustomerAddressListController {

  BuildContext context;
  Function refresh;

  List<Address> address = [];

  AddressProvider _addressProvider = new AddressProvider();
  User user;
  SharedPrefe _sharedPrefe = new SharedPrefe();

  int radioValue = 0;


  OrdersProvider _ordersProvider = new OrdersProvider();

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh= refresh;

    user = User.fromJson(await _sharedPrefe.read('user'));
    _addressProvider.init(context, user);
    _ordersProvider.init(context, user);

    refresh();
  }


  void createOrder() async {
    Address a = Address.fromJson(await _sharedPrefe.read('address') ?? {});
    List<Product> selectedProducts = Product.fromJsonList(await _sharedPrefe.read('order')).toList;
    Order order = new Order(
      idCustomer: user.id,
      idAddress: a.id,
      products: selectedProducts
     );
    ResponseApi responseApi = await _ordersProvider.create(order);
    print('Respuesta de las ordenes: ${responseApi.message}');
  }


  void handleRadioValueChange(int value) async {
    radioValue = value;
    _sharedPrefe.save('address', address[value]);
    
    refresh();
    print('Valor seleccionado: $radioValue');
  }


  Future<List<Address>> getAddress() async {
    address = await _addressProvider.getByUser(user.id);
    Address a = Address.fromJson(await _sharedPrefe.read('address') ?? {});
    int index = address.indexWhere((ad) => ad.id == a.id);

    if (index != -1) {
      radioValue = index;
    }  
    print('SE GUARDO LA DIRECCION: ${a.toJson()}');
  
    return address;
  }
  

  void goToNewAddress() async {
    var result = await Navigator.pushNamed(context, 'customer/address/create');

    if(result != null){
      if(result){
        refresh();
      }
    }
    
     
  }
}