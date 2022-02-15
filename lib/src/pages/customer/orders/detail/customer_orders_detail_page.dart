import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lospescaditosdmary/src/models/order.dart';
import 'package:lospescaditosdmary/src/models/product.dart';
import 'package:lospescaditosdmary/src/pages/customer/orders/detail/customer_orders_detail_controller.dart';
import 'package:lospescaditosdmary/src/utils/relative_time.dart';
import 'package:lospescaditosdmary/src/widgets/no_data_widget.dart';

class CustomerOrdersDetailPage extends StatefulWidget {

  Order order;

  CustomerOrdersDetailPage({Key key, @required this.order}) : super(key: key);

  @override
  _CustomerOrdersDetailPageState createState() => _CustomerOrdersDetailPageState();
}

class _CustomerOrdersDetailPageState extends State<CustomerOrdersDetailPage> {

  CustomerOrdersDetailController _con = new CustomerOrdersDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orden #${_con.order?.id ?? ''}'),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 18, right: 15),
            child: Text(
              'Total: ${_con.total}\$',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                color: Colors.grey[400],
                endIndent: 30, // DERECHA
                indent: 30, //IZQUIERDA
              ),
              SizedBox(height: 10),
              _textData('Repartidor:', '${_con.order?.delivery?.name ?? 'No asignado'} ${_con.order?.delivery?.lastname ?? ''}'),
              _textData('Dirección:', '${_con.order?.address?.address ?? ''}'),
              _textData(
                  'Fecha del pedido:',
                  '${RelativeTime.getRelativeTime(_con.order.timestamp ?? 0)}'
              ),
              _con.order?.status == 'EN CAMINO' ? _buttonNext() : Container()
            ],
          ),
        ),
      ),
      body: _con.order.products.length > 0
          ? ListView(
        children: _con.order.products.map((Product product) {
          return _cardProduct(product);
        }).toList(),
      )
          : NoDataWidget(text: 'Ningun producto agregado',),
    );
  }

  Widget _textData(String title, String content) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          content,
          maxLines: 2,
        ),
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 20),
      child: ElevatedButton(
        onPressed: _con.updateOrder,
        style: ElevatedButton.styleFrom(
            primary: Colors.blue,
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
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  'SEGUIR ENTREGA',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product?.name ?? '',

                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  _textPrice(product),
                  SizedBox(height: 10),
                  Text(
                    'Cantidad: ${product.quantity}',
                    style: TextStyle(
                        fontSize: 13
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _textPrice(Product product) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        '${product.price* product.quantity}\$',
        style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      width: 50,
      height: 50,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[200]
      ),
      child: FadeInImage(
        image: product.image1 != null
            ? NetworkImage(product.image1)
            : AssetImage('assets/img/no-image.png'),
        fit: BoxFit.contain,
        fadeInDuration: Duration(milliseconds: 50),
        placeholder: AssetImage('assets/img/no-image.png'),
      ),
    );
  }


  void refresh() {
    setState(() {});
  }
}