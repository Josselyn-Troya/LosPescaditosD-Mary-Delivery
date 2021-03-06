import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/models/address.dart';
import 'package:lospescaditosdmary/src/models/order.dart';
import 'package:lospescaditosdmary/src/models/product.dart';
import 'package:lospescaditosdmary/src/models/response_api.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/provider/address_provider.dart';
import 'package:lospescaditosdmary/src/provider/notification_provider.dart';
import 'package:lospescaditosdmary/src/provider/orders_provider.dart';
import 'package:lospescaditosdmary/src/provider/users_provider.dart';
import 'package:lospescaditosdmary/src/utils/my_validations.dart';
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

  ///
  NotificationProvider notificationProvider = new NotificationProvider();
  UsersProvider _usersProvider = new UsersProvider();
  List<String> tokens =[];

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh= refresh;

    user = User.fromJson(await _sharedPrefe.read('user'));
    _addressProvider.init(context, user);
    _ordersProvider.init(context, user);

    ///


    refresh();
  }


  void sendNotification(){

    List<String> registration_ids = [];
    tokens.forEach((token) {
      if(token != null){
        registration_ids.add(token);
      }
    });

    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    };
    notificationProvider.sendMultipleMessage(registration_ids, data, 'ORDEN NUEVA', 'Un cliente ha realizado un pedido nuevo');
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
    if(address.isEmpty){
      MyValidations.show(context, 'No se selecciono ninguna direcci??n');
    }else{
      Navigator.pushNamedAndRemoveUntil(context, 'customer/products/list', (route) => false);
      ///
      _usersProvider.init(context, sessionUser: user);
      tokens = await _usersProvider.getAdminNotification();
      sendNotification();
      MyValidations.show(context, 'Orden creada correctamente, revisar en "Mis compras');
    }

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