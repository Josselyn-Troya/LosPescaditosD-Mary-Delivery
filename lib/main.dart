import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/pages/admin/orders/list/admin_orders_list_page.dart';
import 'package:lospescaditosdmary/src/pages/customer/products/list/customer_products_list_page.dart';
import 'package:lospescaditosdmary/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:lospescaditosdmary/src/pages/login/login_page.dart';
import 'package:lospescaditosdmary/src/pages/register/register_page.dart';
import 'package:lospescaditosdmary/src/pages/roles/roles_pages.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({ Key key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login' :(BuildContext context) => LoginPage(),
        'register' :(BuildContext context) => RegisterPage(),
        'roles' :(BuildContext context) => RolesPage(),
        'customer/products/list' :(BuildContext context) => CustomerProductsListPage(),
        'admin/orders/list' :(BuildContext context) => AdminOrdersListPage(),
        'delivery/orders/list' :(BuildContext context) => DeliveryOrdersListPage(),
      },
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        primaryColor: MyColors.primaryColor
      ),
      
    );
  }
}