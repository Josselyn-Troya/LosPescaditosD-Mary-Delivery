import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
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
      /* _imageSlideshow(), */
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
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 50, top: 6),
              height: 30,
              child: Image.asset('assets/img/carrito_compras.png')
            ),
          )
          ],
        ),
      ),
    );
  }

  Widget _addOrRemove(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 17),
      child: Row(children: [
        IconButton(
          onPressed: _con.addItem, 
          icon: Icon(
            Icons.add_circle_outline_rounded,
            color: Colors.grey,
            size: 30,
          )
        ),
          Text(
            '${_con.counter}',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.grey
          )
        ),
         IconButton(
          onPressed: _con.removeItem, 
          icon: Icon(
            Icons.remove_circle_outline_rounded,
            color: Colors.grey,
            size: 30,
          )),
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
          fontSize: 13,
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
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      )
    );
  }

 /*  Widget _imageSlideshow(){
    return Stack(
        children: [
          ImageSlideshow(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            initialPage: 0,
            indicatorColor: MyColors.primaryColor,
            indicatorBackgroundColor: Colors.grey,
            children: [
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
            ],

            /// Called whenever the page in the center of the viewport changes.
            onPageChanged: (value) {
              print('Page changed: $value');
            },

            autoPlayInterval: 10000,

            /* /// Loops back to first slide.
            isLoop: true, */
          ),
          Positioned(
            left: 10,
            top: 5,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_back_ios_new,
              color: MyColors.primaryColor,
            ),
          ))
        ]
    ); */
      
  //}

  void refresh(){
    setState(() {
      
    });
  }
}