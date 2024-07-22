import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserServiceRequestInfo {
  LatLng originLatLng;
  String originAddress;
  String service;
  String userName;
  String userPhone;

  UserServiceRequestInfo(
    this.service, {
    required this.originLatLng,
    required this.userName,
    required this.userPhone,
    required this.originAddress,
  });
}
