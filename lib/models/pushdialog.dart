import 'package:google_maps_flutter/google_maps_flutter.dart';

class Pushnotification {
  LatLng? originLatLng;
  LatLng? destinationLatLng;
  String? originAddress;
  String? destinationAddress;
  String? serviceID;
  String? service;
  String? userName;
  String? userPhone;

  Pushnotification({
    this.originLatLng,
    this.destinationLatLng,
    this.destinationAddress,
    this.serviceID,
    this.userName,
    this.userPhone,
    this.originAddress,
  });
}
