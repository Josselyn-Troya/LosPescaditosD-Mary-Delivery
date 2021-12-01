import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lospescaditosdmary/src/pages/customer/products/list/customer_products_list_controller.dart';

class CustomerProductsListPage extends StatefulWidget {
  const CustomerProductsListPage({ Key key }) : super(key: key);

  @override
  _CustomerProductsListPageState createState() => _CustomerProductsListPageState();
}

class _CustomerProductsListPageState extends State<CustomerProductsListPage> {

  CustomerProductsListController _con = new CustomerProductsListController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _con.logout ,
          child: Text('Cerrar session'),
        ),
      ),
    );
  }
}