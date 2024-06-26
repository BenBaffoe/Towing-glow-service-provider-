import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserServiceRequestInfo {
  LatLng? originLatLng;
  LatLng? destinationLatLng;
  String? originAddress;
  String? destinationAddress;
  String? serviceRequestID;
  String? userName;
  String? userPhone;

  UserServiceRequestInfo({
    this.originLatLng,
    this.destinationLatLng,
    this.destinationAddress,
    this.serviceRequestID,
    this.userName,
    this.userPhone,
    this.originAddress,
  });
}
