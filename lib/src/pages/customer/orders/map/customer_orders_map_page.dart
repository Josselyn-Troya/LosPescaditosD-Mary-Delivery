import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lospescaditosdmary/src/pages/customer/orders/map/customer_orders_map_controller.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';

class CustomerOrdersMapPage extends StatefulWidget {
  const CustomerOrdersMapPage({ Key key }) : super(key: key);

  @override
  _CustomerOrdersMapPageState createState() => _CustomerOrdersMapPageState();
}

class _CustomerOrdersMapPageState extends State<CustomerOrdersMapPage> {

  CustomerOrdersMapController _con = new CustomerOrdersMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                  child: _googleMaps()
              ),

              SafeArea(
                child: Column(

                  children: [

                    Spacer(),
                    _cardOrder(),

                  ],
                ),
              )

            ]
        )
    );
  }


  Widget _cardOrder() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),

      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _listAddress(_con.order?.address?.neighborhood, 'Barrio', Icons.my_location),
            _listAddress(_con.order?.address?.address, 'Direccion', Icons.location_on),
            Divider(color: Colors.grey[400], endIndent: 30, indent: 30,),
            _customerInfo()
          ]
        ),
      ),
    );
  }

  Widget _customerInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            child: FadeInImage(
              image: _con.order?.delivery?.image != null
                  ? NetworkImage(_con.order?.delivery?.image)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '${_con.order?.delivery?.name ?? ''} ${_con.order?.delivery?.lastname ?? ''}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16
              ),
              maxLines: 1,
            ),
          ),
          Spacer(),

        ],
      ),
    );
  }


  Widget _listAddress(String title, String subtitle, IconData iconData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        title: Text(
          title ?? '',
          style: TextStyle(
              fontSize: 13
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(iconData),
      ),
    );
  }


  Widget _googleMaps(){
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }



  void refresh(){
    if(!mounted) return;
    setState(() {

    });
  }
}