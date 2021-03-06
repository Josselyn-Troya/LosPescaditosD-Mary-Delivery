import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lospescaditosdmary/src/models/product.dart';
import 'package:lospescaditosdmary/src/pages/customer/products/detail/customer_products_detail_controller.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';

class CustomerProductsDetailPage extends StatefulWidget {
  Product product;
   CustomerProductsDetailPage({ Key key, @required this.product }) : super(key: key);

  @override
  _CustomerProductsDetailPageState createState() => _CustomerProductsDetailPageState();
}

class _CustomerProductsDetailPageState extends State<CustomerProductsDetailPage> {
  
  CustomerProductsDetailController _con = new CustomerProductsDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.product);
    });

  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
    child: Column(children: [
      _imageSlideshow(), 
      _productName(),
      _productDescription(),
      Spacer(),
      _addOrRemove(),
      _buttonShopping()
    ],)
    );
  }

  Widget _buttonShopping(){
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
      child: ElevatedButton(
        onPressed: _con.addToCar,
        style: ElevatedButton.styleFrom(
          primary: MyColors.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          )
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'AGREGAR AL CARRITO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              )
            ),

          ],
        ),
      ),
    );
  }

  Widget _addOrRemove(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        GestureDetector(
          onTap:
            _con.removeItem,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)
                ),
                color: Colors.grey[200]
            ),
            child: Text('-',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: Colors.grey[200],
          child: Text('${_con.counter}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),),
        ),
        GestureDetector(
          onTap:
            _con.addItem,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)
                ),
                color: Colors.grey[200]
            ),
            child: Text('+',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

          ),
        ),
         
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Text(
              '${_con.productPrice ?? 0}\$',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ))
      ],)
    );
  }

  Widget _productDescription(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 15),
      child: Text(
        _con.product.description ?? '',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey
        ),
      )
    );
  }

  Widget _productName(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 30),
      child: Text(
        _con.product.name ?? '',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold
        ),
      )
    );
  }

  Widget _imageSlideshow(){
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      child: CarouselSlider(items: [
        FadeInImage(
                  image: _con.product?.image1 != null
                      ? NetworkImage(_con.product.image1)
                      : AssetImage('assets/img/no-image.png'),
                  fit: BoxFit.contain,
                  fadeInDuration: Duration(milliseconds: 50),
                  placeholder: AssetImage('assets/img/no-image.png'),
                ),
                FadeInImage(
                  image: _con.product?.image2 != null
                      ? NetworkImage(_con.product.image2)
                      : AssetImage('assets/img/no-image.png'),
                  fit: BoxFit.contain,
                  fadeInDuration: Duration(milliseconds: 50),
                  placeholder: AssetImage('assets/img/no-image.png'),
                ),
      ],options: CarouselOptions(
        height: 400,
        initialPage: 0,
        autoPlay: true,
        autoPlayCurve: Curves.easeInOut,
        enlargeCenterPage: true,
        autoPlayInterval: Duration(seconds: 3),
        scrollDirection: Axis.horizontal

      ),
      ),
              
    );
      
  }

  void refresh(){
    setState(() {
      
    });
  }
}