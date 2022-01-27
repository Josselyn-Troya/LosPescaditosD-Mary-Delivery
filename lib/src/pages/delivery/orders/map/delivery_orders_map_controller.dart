import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:lospescaditosdmary/src/api/environment.dart';
import 'package:lospescaditosdmary/src/models/order.dart';
import 'package:lospescaditosdmary/src/models/response_api.dart';
import 'package:lospescaditosdmary/src/models/user.dart';
import 'package:lospescaditosdmary/src/provider/orders_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:lospescaditosdmary/src/utils/my_colors.dart';
import 'package:lospescaditosdmary/src/utils/shared_prefe.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryOrdersMapController {

  BuildContext context;
  Function refresh;
  Position _position;

  //obtener eventos en tiempo real o eventos ejecutandose constantemente
  StreamSubscription _positionStreamSubscription;

  String addressName;
  LatLng addressLatLng;

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(0.003035, -79.393735),
      zoom: 15
  );

  Completer<GoogleMapController> _mapController = Completer();
  BitmapDescriptor deliveryMarker;
  BitmapDescriptor homeMarker;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Order order;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  OrdersProvider _ordersProvider = new OrdersProvider();
  User user;
  SharedPrefe _sharedPrefe = new SharedPrefe();

  double _distanceDelivery;

  IO.Socket socket;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    order = Order.fromJson(ModalRoute.of(context).settings.arguments as Map<String, dynamic>);
    user = User.fromJson(await _sharedPrefe.read('user'));
    _ordersProvider.init(context, user);
    deliveryMarker = await createMarker('assets/img/pez.png');
    homeMarker = await createMarker('assets/img/hogar.png');

    socket = IO.io('http://${Environment.API_DELIVERY}/orders/delivery', <String, dynamic> {
      'transports' : ['websocket'],
      'autoConnect' : false
    });
    socket.connect();


    checkGPS();

    refresh();
  }


  void saveLocation() async {
    order.lat = _position.latitude;
    order.lng = _position.longitude;
    await _ordersProvider.updateLatLng(order);
  }

  void deliveryEmitPosition(){
    socket.emit('position', {
      'id_order': order.id,
      'lat': _position.latitude,
      'lng': _position.longitude,

    });
  }


  void isCloseDeliveryPosition() {
    _distanceDelivery = Geolocator.distanceBetween(
        _position.latitude,
        _position.longitude,
        order.address.lat,
        order.address.lng
    );
    print('-------- DIOSTANCIA ${_distanceDelivery} ----------');
  }

  void dispose(){
    _positionStreamSubscription?.cancel();
    socket?.disconnect();
  }

  void updateDelivered() async {
   // if(_distanceDelivery <= 200){
      ResponseApi responseApi = await _ordersProvider.updateDelivered(order);
   //   if(responseApi.success){
        Navigator.pushNamedAndRemoveUntil(context, 'delivery/orders/list', (route) => false);
     // }else{
     //   MyValidations.show(context, 'Debe realizar la entrega antes de actualizar el estado');
     // }
    //}
  }

  void phone() {
    launch("tel://${order?.customer?.phone}");
  }


  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS,
        pointFrom,
        pointTo
    );

    for(PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: MyColors.primaryColor,
        points: points,
        width: 6
    );

    polylines.add(polyline);

    refresh();
  }


  void addMarker( String markerId, double lat, double lng, String title, String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content)
    );
    markers[id] = marker;
    refresh();
  }

  void selectPoint() {
    Map<String, dynamic> data = {
      'address': addressName,
      'lat': addressLatLng.latitude,
      'lng': addressLatLng.longitude,
    };

    Navigator.pop(context, data);
  }


  Future<BitmapDescriptor> createMarker(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
    return descriptor;
  }


  Future<Null> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng);

      if (address != null) {
        if (address.length > 0) {
          String direction = address[0].thoroughfare;
          String street = address[0].subThoroughfare;
          String city = address[0].locality;
          String province = address[0].administrativeArea;
          addressName = '$direction #$street, $city, $province';
          addressLatLng = new LatLng(lat, lng);


          refresh();
        }

      }

    }
  }


  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]');
    _mapController.complete(controller);
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnabled) {
      updateLocation();
    }
    else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }


  void updateLocation() async{
    try {
      await _determinePosition(); // obtiene la posicion actual y solicita los permisos
      _position = await Geolocator.getLastKnownPosition(); // LAT Y LNG
      saveLocation();
      animateCameraPosition(_position.latitude, _position.longitude);

      addMarker('delivery', _position.latitude, _position.longitude, 'Tu posición', '', deliveryMarker);
      addMarker('home', order.address.lat, order.address.lng, 'Lugar de entrega', '', homeMarker);

      LatLng from = new LatLng(_position.latitude, _position.longitude);
      LatLng to = new LatLng(order.address.lat, order.address.lng);

      setPolylines(from, to);

      //cuando el delivery se mueva volvera a trazar la ruta para establecerlo en la posicion actual
      _positionStreamSubscription = Geolocator.getPositionStream(
          desiredAccuracy: LocationAccuracy.best,
          distanceFilter: 1
      ).listen((Position position) {

        _position = position;

        deliveryEmitPosition();

        addMarker('delivery', _position.latitude, _position.longitude, 'Tu posición', '', deliveryMarker);
        animateCameraPosition(_position.latitude, _position.longitude);
        isCloseDeliveryPosition();
        refresh();
      });

    } catch (e) {
      print('Erorr: $e');
    }
  }

  Future animateCameraPosition(double lat, double lng) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(lat, lng),
              zoom: 13,
              bearing: 0
          )
      ));
    }
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

}