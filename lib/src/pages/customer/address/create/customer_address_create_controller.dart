import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lospescaditosdmary/src/models/address.dart';
import 'package:lospescaditosdmary/src/models/response_api.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/pages/customer/address/map/customer_address_map_page.dart';
import 'package:lospescaditosdmary/src/provider/address_provider.dart';
import 'package:lospescaditosdmary/src/utils/my_validations.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class  CustomerAddressCreateController {

  BuildContext context;
  Function refresh;

  TextEditingController pointController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController neighborhoodController = new TextEditingController();
  
  Map<String, dynamic> point;

  AddressProvider _addressProvider = new AddressProvider();
  User user;
  SharedPrefe _sharedPrefe = new SharedPrefe();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh= refresh;
    user = User.fromJson(await _sharedPrefe.read('user'));
    _addressProvider.init(context, user);
  }

  void createAddress() async {
    String addressName = addressController.text;
    String neighborhood = neighborhoodController.text;
    double lat = point['lat'] ?? 0;
    double lng = point['lng'] ?? 0;

    if (addressName.isEmpty || neighborhood.isEmpty || lat == 0 || lng == 0) {
      MyValidations.show(context, 'Debe completar todos los campos');
      return;
    }

    Address address = new Address(
      address: addressName,
      neighborhood: neighborhood,
      lat: lat,
      lng: lng,
      idUser: user.id
    );

    ResponseApi responseApi = await _addressProvider.create(address);

    if (responseApi.success) {

      address.id = responseApi.data;
      _sharedPrefe.save('address', address);

      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pop(context, true);

      //////////////////////
    }
  }

  void openMap() async {
    point = await showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => CustomerAddressMapPage()
    );

    if(point != null){
      pointController.text = point['address'];
      refresh();
    }

  }
 
}