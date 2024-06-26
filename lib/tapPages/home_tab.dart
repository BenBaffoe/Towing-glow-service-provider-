import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_providers_glow/Assistants/assitant_method.dart';

import 'package:service_providers_glow/global/global.dart';
import 'package:service_providers_glow/pushnotification/push_notification_system.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final Completer<GoogleMapController> googleMapCompleteContoller =
      Completer<GoogleMapController>();

  GoogleMapController? controllerGoogleMap;

  var geoLocation = Geolocator();

  checkLocationPermission() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateServicePosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    serviceCurrentPosition = currentPosition;

    LatLng latLngPosition = LatLng(
        serviceCurrentPosition!.latitude, serviceCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);

    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            serviceCurrentPosition!, context);
    print("This is our address = $humanReadableAddress");
  }

  LocationPermission? _locationPermission;

  readCurrentDriverPermission() async {
    currentUser = firebaseAuth.currentUser;

    FirebaseDatabase.instance
        .ref()
        .child("Service Providers")
        .child(currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        onlineServicedata.id = (snap.snapshot.value as Map)["id"];
        onlineServicedata.name = (snap.snapshot.value as Map)["name"];
        onlineServicedata.phone = (snap.snapshot.value as Map)["phone"];
        onlineServicedata.email = (snap.snapshot.value as Map)["email"];
        // onlineServicedata.address = (snap.snapshot.value as Map)["address"];
        // onlineServicedata.address =
        //     (snap.snapshot.value as Map)["car_details"]["car_model"];
        // onlineServicedata.address =
        //     (snap.snapshot.value as Map)["car_details"]["car_number"];
        // onlineServicedata.address =
        //     (snap.snapshot.value as Map)["car_details"]["car_color"];

        // serviceVehicleType =
        //     (snap.snapshot.value as Map)["car_details"]["type"];
      }
    });
  }

  String statusText = "New Offline";
  Color buttonColor = Colors.grey;
  bool isDriverActive = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkLocationPermission();
    readCurrentDriverPermission();
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(top: 40),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: googlePlexIntitialPosition,
            onMapCreated: (GoogleMapController mapContoller) {
              controllerGoogleMap = mapContoller;
              // mapContoller.setMapStyle(themeforMap);
              googleMapCompleteContoller.complete(mapContoller);
              locateServicePosition();
              // getCurrentLiveLocationOfUser();
            },
          ),
          statusText != "Online"
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Colors.black87,
                )
              : Container(),
          Positioned(
            top: statusText != "Online"
                ? MediaQuery.of(context).size.height * 0.45
                : 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isDriverActive != true) {
                      serviceProviderOnline();
                      updateDriversLocationAtRealTime();

                      setState(() {
                        statusText = "Online";
                        isDriverActive = true;
                      });
                    } else {
                      serviceProviderOffline();
                      setState(() {
                        statusText = "Offline";
                        isDriverActive = false;
                      });
                      Fluttertoast.showToast(msg: "You're offline");
                    }
                  },
                  //   Fluttertoast.showToast(
                  //       msg: "Please select a vehicle from above");
                  // }
                  // setState(() {
                  //   searchNearestOnlineDrivers(selectedVehicleType);
                  //   saveSelection();
                  // });
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: const Size(200, 40),
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                          side: const BorderSide(style: BorderStyle.solid))),
                  child: Text(
                    isDriverActive ? "Online" : "Now Offline",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Positioned(
              top: 20,
              left: 20,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Drawer()),
                    );
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  serviceProviderOnline() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    serviceCurrentPosition = pos;

    Geofire.initialize("activeService");
    Geofire.setLocation(currentUser!.uid, serviceCurrentPosition!.latitude,
        serviceCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("Service Providers")
        .child(currentUser!.uid)
        .child("newRideStatus");

    ref.set("idle");
    ref.onValue.listen((event) {});
  }

  updateDriversLocationAtRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      if (isDriverActive == true) {
        Geofire.setLocation(currentUser!.uid, serviceCurrentPosition!.latitude,
            serviceCurrentPosition!.longitude);
      }
      LatLng latLng = LatLng(
          serviceCurrentPosition!.latitude, serviceCurrentPosition!.longitude);

      controllerGoogleMap!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  serviceProviderOffline() {
    Geofire.removeLocation(currentUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("Service Providers")
        .child(currentUser!.uid)
        .child("newRideStatus");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(Duration(milliseconds: 2000), () {
      SystemChannels.platform.invokeMethod("SystemNavigator.pop");
    });
  }
}
