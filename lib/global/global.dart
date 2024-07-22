import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_providers_glow/models/directions_details_info.dart';
import 'package:service_providers_glow/models/serviceproviderdata.dart';
import 'package:service_providers_glow/models/user_modals.dart';

UserModel? userModelCurrentInfo;

String driverCarDetails = "";

String driverName = "";

String cloudMessagingServerToken = "";

ServiceData onlineServicedata = ServiceData();

List serviceProviderList = [];

double countRatings = 0.0;

String userDropOffAddress = "";

String serviceType = '';

Position? serviceCurrentPosition;

final FirebaseAuth auth = FirebaseAuth.instance;

String titleStarsRating = "";

var serviceProviderLocation;

String userName = "";

// LatLng? driverPosition;
LatLng? driverPosition;
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscription;

// UserModel? u serModelCurrentInfo;

Future<void> getData(String _nameController, String _emailController,
    String _phoneController) async {
  CollectionReference userInfo =
      FirebaseFirestore.instance.collection('userInfo');

  return userInfo
      .add({
        'Username': _nameController.toString(),
        'Email': _emailController.toString(),
        'Phone': _phoneController.toString(),
      })
      .then((value) => print('New user added'))
      .catchError((error) => print('Failed to add user'));
}

String humanReadableAddress = '';

String username = "";
String googlesMapKey = "AIzaSyBqtAzED0r5rQvQjsncU10np2bIAUsg6ZY";
const CameraPosition googlePlexIntitialPosition = CameraPosition(
    bearing: 244.64,
    target: LatLng(6.6833, -1.6163),
    tilt: 59.440717697143555,
    zoom: 13.151926040649414);

DirectionsDetailsInfo? serviceDirectionDetailsInfo;
