import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/pages/customer/products/list/customer_products_list_page.dart';
import 'package:lospescaditosdmary/src/pages/login/login_page.dart';
import 'package:lospescaditosdmary/src/pages/register/register_page.dart';
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
        'customer/products/list' :(BuildContext context) => CustomerProductsListPage(),
      },
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        primaryColor: MyColors.primaryColor
      ),
      
    );
  }
}