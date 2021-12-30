import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  String text;
   NoDataWidget({ Key key, this.text }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
        Image.asset('assets/img/caja_vacia.png'),
        Text(text)
      ],),
    );
  }
}