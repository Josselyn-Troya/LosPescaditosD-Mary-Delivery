
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lospescaditosdmary/src/models/order.dart';
import 'package:lospescaditosdmary/src/models/product.dart';
import 'package:lospescaditosdmary/src/models/response_api.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/provider/notification_provider.dart';
import 'package:lospescaditosdmary/src/provider/orders_provider.dart';
import 'package:lospescaditosdmary/src/provider/users_provider.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';

class AdminOrdersDetailController {

  BuildContext context;
  Function refresh;

  Product product;

  int counter = 1;
  double productPrice;

  SharedPrefe _sharedPref = new SharedPrefe();

  double total = 0;
  Order order;

  User user;
  List<User> users = [];
  UsersProvider _usersProvider = new UsersProvider();
  OrdersProvider _ordersProvider = new OrdersProvider();

  String idDelivery;

  NotificationProvider notificationProvider = new NotificationProvider();

  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    user = User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context, sessionUser: user);
    _ordersProvider.init(context, user);

    getTotal();
    getUsers();
    refresh();
  }

  void sendNotification(String tokenDelivery){
    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    };
    notificationProvider.sendMessage(tokenDelivery, data, 'PEDIDO ASIGNADO', 'Tienes una orden asignada');
  }

  void updateOrder() async {
    if (idDelivery != null) {
      order.idDelivery = idDelivery;
      ResponseApi responseApi = await _ordersProvider.updateDespatched(order);
      
      User deliveryUser = await _usersProvider.getById(order.idDelivery);
      print('TOKEN DEL DELIVERY DE LAS NOTIFICACIONES ${deliveryUser.notificationToken}');
      sendNotification(deliveryUser.notificationToken);
      
      Fluttertoast.showToast(msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context, true);
    }
    else {
      Fluttertoast.showToast(msg: 'Selecciona el repartidor');
    }
  }

  void getUsers() async {
    users = await _usersProvider.getDelivery();
    refresh();
  } 

  void getTotal() {
    total = 0;
    order.products.forEach((product) {
      total = total + (product.price * product.quantity);
    });
    refresh();
  }

}