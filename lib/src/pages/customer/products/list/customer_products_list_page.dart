import 'package:flutter/material.dart';

class CustomerProductsListPage extends StatefulWidget {
  const CustomerProductsListPage({ Key key }) : super(key: key);

  @override
  _CustomerProductsListPageState createState() => _CustomerProductsListPageState();
}

class _CustomerProductsListPageState extends State<CustomerProductsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('productos'),
      ),
    );
  }
}