import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lospescaditosdmary/src/pages/customer/address/map/customer_address_map_controller.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';

class CustomerAddressMapPage extends StatefulWidget {
  const CustomerAddressMapPage({ Key key }) : super(key: key);

  @override
  _CustomerAddressMapPageState createState() => _CustomerAddressMapPageState();
}

class _CustomerAddressMapPageState extends State<CustomerAddressMapPage> {

  CustomerAddressMapController _con = new CustomerAddressMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.init(context, refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubica tu dirección exacta'),
      ),
      body: Stack(
        children: [
          _googleMaps(),
          Container(
            alignment: Alignment.center,
            child: _iconMyLocation(),
          ),
           Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.topCenter,
            child: _cardAddress(),
          ),
           Container(
            alignment: Alignment.bottomCenter,
            child: _buttonAccept(),
          )

        ]
      )
    );
  }


  Widget _buttonAccept() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 70),
      child: ElevatedButton(
        onPressed: _con.selectPoint,
        child: Text(
            'SELECCIONAR ESTA UBICACIÓN'
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            primary: MyColors.primaryColor
        ),
      ),
    );
  }


  Widget _cardAddress() {
    return Container(
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            _con.addressName ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }


  Widget _iconMyLocation() {
    return Image.asset(
      'assets/img/pin.png',
      width: 65,
      height: 65,
    );
  }

  Widget _googleMaps(){
    return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _con.initialPosition,
        onMapCreated: _con.onMapCreated,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        onCameraMove: (position){
          _con.initialPosition = position;
        },
        onCameraIdle: () async {
          await _con.setLocationDraggableInfo();
        },
      );
  }



   void refresh(){
    setState(() {
      
    });
  }
}