import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/models/order.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/pages/admin/orders/detail/admin_orders_detail_page.dart';
import 'package:lospescaditosdmary/src/provider/orders_provider.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AdminOrdersListController {
  BuildContext context;
  SharedPrefe _sharedPrefe = new SharedPrefe();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;
 
  User user;

  List<String> status = ['PEDIDO', 'DESPACHADO', 'EN CAMINO', 'ENTREGADO'];
  OrdersProvider _ordersProvider = new OrdersProvider();

  bool isUpdated;

  Future init(BuildContext context, Function refresh) async{
    this.context = context; 
    this.refresh = refresh;
    user = User.fromJson(await _sharedPrefe.read('user'));
    _ordersProvider.init(context, user);
    refresh();
  }

   Future<List<Order>> getOrders(String status) async {
    return await _ordersProvider.getByStatus(status);
  }

  void openModalBottomSheet(Order order) async {
    isUpdated = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => AdminOrdersDetailPage(order: order)
    );

    if (isUpdated) {
      refresh();
    }
  }


  void logout(){
    _sharedPrefe.logout(context, user.id);
  }

  void goToCategoryCreate(){
    Navigator.pushNamed(context, 'admin/categories/create');
  }

  void goToProductCreate(){
    Navigator.pushNamed(context, 'admin/products/create');
  }

  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

}