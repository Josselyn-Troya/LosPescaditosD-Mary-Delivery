import 'package:flutter/material.dart';

class AdminOrdersListPage extends StatefulWidget {
  const AdminOrdersListPage({ Key key }) : super(key: key);

  @override
  _AdminOrdersListPageState createState() => _AdminOrdersListPageState();
}

class _AdminOrdersListPageState extends State<AdminOrdersListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
        child: Text('Administrador'),
      ),
    );
  }
}