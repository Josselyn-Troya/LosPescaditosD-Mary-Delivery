import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lospescaditosdmary/src/pages/admin/categories/create/admin_categories_create_page.dart';
import 'package:lospescaditosdmary/src/pages/admin/orders/list/admin_orders_list_page.dart';
import 'package:lospescaditosdmary/src/pages/admin/products/create/admin_products_create_page.dart';
import 'package:lospescaditosdmary/src/pages/customer/address/create/customer_address_create_page.dart';
import 'package:lospescaditosdmary/src/pages/customer/address/list/customer_address_list_page.dart';
import 'package:lospescaditosdmary/src/pages/customer/address/map/customer_address_map_page.dart';
import 'package:lospescaditosdmary/src/pages/customer/orders/create/customer_orders_create_page.dart';
import 'package:lospescaditosdmary/src/pages/customer/orders/list/customer_orders_list_page.dart';
import 'package:lospescaditosdmary/src/pages/customer/orders/map/customer_orders_map_page.dart';
import 'package:lospescaditosdmary/src/pages/customer/products/list/customer_products_list_page.dart';
import 'package:lospescaditosdmary/src/pages/customer/update/customer_update_page.dart';
import 'package:lospescaditosdmary/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:lospescaditosdmary/src/pages/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:lospescaditosdmary/src/pages/login/login_page.dart';
import 'package:lospescaditosdmary/src/pages/register/register_page.dart';
import 'package:lospescaditosdmary/src/pages/roles/roles_pages.dart';
import 'package:lospescaditosdmary/src/provider/notification_provider.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';

NotificationProvider notificationProvider = new NotificationProvider();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  notificationProvider.initNotifications();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({ Key key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationProvider.onMessageListener();
  }

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
        'customer/update' :(BuildContext context) => CustomerUpdatePage(),
        'customer/orders/create' :(BuildContext context) => CustomerOrdersCreatePage(),
        'customer/address/list' :(BuildContext context) => CustomerAddressListPage(),
        'customer/address/create' :(BuildContext context) => CustomerAddressCreatePage(),
        'customer/address/map' :(BuildContext context) => CustomerAddressMapPage(),
        'customer/orders/list' :(BuildContext context) => CustomerOrdersListPage(),
        'customer/orders/map' :(BuildContext context) => CustomerOrdersMapPage(),

        'admin/orders/list' :(BuildContext context) => AdminOrdersListPage(),
        'admin/categories/create' :(BuildContext context) => AdminCategoriesCreatePage(),
        'admin/products/create' :(BuildContext context) => AdminProductsCreatePage(),

        'delivery/orders/list' :(BuildContext context) => DeliveryOrdersListPage(),
        'delivery/orders/map' :(BuildContext context) => DeliveryOrdersMapPage(),

      },
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        primaryColor: MyColors.primaryColor,
        appBarTheme: AppBarTheme(elevation: 0)
      ),
      
    );
  }
}