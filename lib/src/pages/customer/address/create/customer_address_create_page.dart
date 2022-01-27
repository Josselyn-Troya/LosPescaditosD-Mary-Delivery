import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lospescaditosdmary/src/pages/customer/address/create/customer_address_create_controller.dart';
import 'package:lospescaditosdmary/src/utils/my_colors.dart';


class CustomerAddressCreatePage extends StatefulWidget {
  const CustomerAddressCreatePage({ Key key }) : super(key: key);

  @override
  _CustomerAddressCreatePageState createState() => _CustomerAddressCreatePageState();
}

class _CustomerAddressCreatePageState extends State<CustomerAddressCreatePage> {

  CustomerAddressCreateController _con = new CustomerAddressCreateController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva dirección'),
      ),
      bottomNavigationBar: _buttonAccept(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _textCompleteData(),
            _textFieldRefPoint(),
            _textFieldNeighborhood(),
            _textFieldAddress(),
          ],
        ),
      ),
    );
  }


   Widget _textFieldAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.addressController,
        decoration: InputDecoration(
          labelText: 'Dirección o punto de referencia',
          suffixIcon: Icon(
            Icons.location_on,
            color: MyColors.primaryColor,
          )
        ),
      ),
    );
  }

  Widget _textFieldNeighborhood() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.neighborhoodController,
        decoration: InputDecoration(
          labelText: 'Barrio',
          suffixIcon: Icon(
            Icons.location_city,
            color: MyColors.primaryColor,
          )
        ),
      ),
    );
  }

  Widget _textFieldRefPoint() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.pointController,
        onTap: _con.openMap,
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        decoration: InputDecoration(
          labelText: 'Dirección en el mapa',
          suffixIcon: Icon(
            Icons.map_outlined,
            color: MyColors.primaryColor,
          )
        ),
      ),
    );
  }

  

  Widget _textCompleteData() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Text(
        'Completa los datos',
        style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }


  Widget _buttonAccept() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(
        onPressed: _con.createAddress,
        child: Text(
            'CREAR DIRECCIÓN'
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

  void refresh(){
    setState(() {
      
    });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}