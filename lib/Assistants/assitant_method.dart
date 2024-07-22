import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:service_providers_glow/Assistants/request_assistant.dart';
import 'package:service_providers_glow/Info/app_info.dart';
import 'package:service_providers_glow/global/global.dart';
import 'package:service_providers_glow/models/directions.dart';
import 'package:service_providers_glow/models/directions_details_info.dart';
import 'package:service_providers_glow/models/user_modals.dart';

class AssistantMethods {
  static void readCurrentOnlineUserInfo() async {
    currentUser = FirebaseAuth.instance.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("Service Providers")
        .child(currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<String> searchAddressForGeographicCoOrdinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googlesMapKey";

    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.recieveRequest(apiUrl);

    if (requestResponse != "Error Occured No Response") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.loactionLatitude = position.latitude;
      userPickUpAddress.loactionLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static Future<DirectionsDetailsInfo?>
      obtainOriginToDestinationDirectionsDetails(
          LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionsDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$googlesMapKey";

    var responseDirectionsApi = await RequestAssistant.recieveRequest(
        urlOriginToDestinationDirectionsDetails);

    if (responseDirectionsApi == "Error Occured ") {
      return null;
    }

    DirectionsDetailsInfo directionsDetailsInfo = DirectionsDetailsInfo();
    directionsDetailsInfo.ePoints =
        responseDirectionsApi["routes"][0]["overview_polyline"]["points"];

    directionsDetailsInfo.distanceText =
        responseDirectionsApi["routes"][0]["legs"][0]["distance"]["text"];

    directionsDetailsInfo.distanceValue =
        responseDirectionsApi["routes"][0]["legs"][0]["distance"]["value"];

    directionsDetailsInfo.durationText =
        responseDirectionsApi["routes"][0]["legs"][0]["duration"]["text"];

    directionsDetailsInfo.durationValue =
        responseDirectionsApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionsDetailsInfo;
  }

  static pauseLiveLocationUpdate() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(firebaseAuth.currentUser!.uid);
  }
}
