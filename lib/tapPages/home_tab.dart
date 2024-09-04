import 'dart:async';
// import 'dart:collection';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:service_providers_glow/Assistants/assitant_method.dart';
import 'package:service_providers_glow/Info/app_info.dart';
import 'package:service_providers_glow/ServiceProviderScreen/Account.dart';
import 'package:service_providers_glow/ServiceProviderScreen/checkservice.dart';

import 'package:service_providers_glow/global/global.dart';
import 'package:service_providers_glow/local_notifications.dart';
import 'package:service_providers_glow/models/user_service_request.dart';
// import 'package:service_providers_glow/pushnotification/notification_dialog_box.dart';
// import 'package:service_providers_glow/pushnotification/push_notification_system.dart';
import 'package:service_providers_glow/tapPages/servicerequests.dart';
// import 'package:service_providers_glow/lib/models/pushdialog.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalNotifications.init();
    checkLocationPermission();
    readCurrentDriverPermission();
    startPeriodicServiceRequestRetrieval();
    // PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    // pushNotificationSystem.initializeCloudMessaging(context);
    // pushNotificationSystem.generateAndGetToken();
    getNotification();
  }

  final Completer<GoogleMapController> googleMapCompleteContoller =
      Completer<GoogleMapController>();

  Map getdata = {};

  Checkservice? checkservice;

  GoogleMapController? controllerGoogleMap;

  UserServiceRequestInfo? userServiceRequestInfo;

  // void getMapValue(Map value) {
  //   seS
  // }

  getNotification() {
    print("Listening for notifications");
    LocalNotifications.onClickedNotification.stream.listen((event) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ServiceRequests(
                    userServiceRequestInfo: userServiceRequestInfo,
                    payload: event,
                  )));
    });
  }

  String address = '';
  String name = '';
  String phone = '';
  String email = '';
  String location = '';

  Future<void> retrieveServiceRequest(String serviceType) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("Service Requests");
    userRef.onValue.listen((event) {
      // Check if there's data
      if (event.snapshot.exists) {
        // Get the data as a Map
        Map<dynamic, dynamic> serviceRequestsMap =
            Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        // Iterate over the service requests
        serviceRequestsMap.forEach((key, value) {
          // Access the 'service' field
          Map<dynamic, dynamic> serviceRequestInfo =
              value as Map<dynamic, dynamic>;
          String? service = serviceRequestInfo['service'] as String?;

          print("$service + servicessssssssssssssssssssssssssssssssssssss");

          if (service != null && serviceType == service) {
            // Retrieve the service request info
            double originLatitude = double.parse(
                serviceRequestInfo['origin']['latitude'].toString());
            double originLongitude = double.parse(
                serviceRequestInfo['origin']['longitude'].toString());
            LatLng origin = LatLng(originLatitude, originLongitude);
            String time = serviceRequestInfo['time'] ?? 'Unknown';
            String userName = serviceRequestInfo['userName'] ?? 'Unknown';
            String originAddress =
                serviceRequestInfo['originAddress'] ?? 'Unknown';
            String userPhone = serviceRequestInfo['userPhone'] ?? 'Unknown';
            String serviceId = serviceRequestInfo['serviceId'] ?? 'Unknown';

            var originLocation =
                Provider.of<AppInfo>(context, listen: false).userPickUpLocation;

            Map originLocations = {
              "latitude": originLocation?.loactionLatitude,
              "longitude": originLocation?.loactionLongitude,
            };

            // Map _userInfo = {
            //   "address": originAddress,
            //   "name": userName,
            //   "phone": userPhone,
            //   "location": origin,

            // };

            userServiceRequestInfo = UserServiceRequestInfo(
              service,
              originLatLng: origin,
              userName: userName,
              userPhone: userPhone,
              originAddress: originAddress,
              serviceProviderLocation: originLocations,
            );

            // history = UserServiceRequestInfo(service,
            //     originLatLng: origin,
            //     userName: userName,
            //     userPhone: userPhone,
            //     originAddress: originAddress,
            //     serviceProviderLocation: serviceProviderLocation);

            originAddress.substring(0, 20);

            LocalNotifications.showSimpleNotification(
              title: 'Service Request',
              body: 'Service request from $userName',
              payload: '$userName',
            );
          }
        });
      }
    });
  }

  void startPeriodicServiceRequestRetrieval() {
    // Define the timer duration
    const duration = Duration(seconds: 30);

    // Set up a timer that triggers every 'duration'
    Timer.periodic(duration, (Timer timer) {
      // Call your existing data retrieval function
      retrieveServiceRequest(serviceType);
    });
  }

  var geoLocation = Geolocator();

  checkLocationPermission() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  Set<Marker> _markers = {};

  Future<void> locateServicePosition() async {
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

    _updateDriverPosition(
        latLngPosition); // Update the position and add the marker
  }

  void _updateDriverPosition(LatLng position) {
    setState(() {
      driverPosition = position;
      _markers.add(
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: driverPosition!,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    });
  }

  // locateServicePosition() async {
  //   Position currentPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   serviceCurrentPosition = currentPosition;

  //   LatLng latLngPosition = LatLng(
  //       serviceCurrentPosition!.latitude, serviceCurrentPosition!.longitude);
  //   CameraPosition cameraPosition =
  //       CameraPosition(target: latLngPosition, zoom: 15);

  //   controllerGoogleMap!
  //       .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  //   String humanReadableAddress =
  //       await AssistantMethods.searchAddressForGeographicCoOrdinates(
  //           serviceCurrentPosition!, context);
  //   print("This is our address = $humanReadableAddress");
  // }

  // drawPolyline() async {
  //   LatLng userLatLng = await locateServicePosition();
  //   print(
  //       'User\'s current position: ${userLatLng.latitude}, ${userLatLng.longitude}');
  //   return userLatLng;
  // }

  LocationPermission? _locationPermission;

  readCurrentDriverPermission() async {
    currentUser = firebaseAuth.currentUser;

    FirebaseDatabase.instance
        .ref()
        .child("userInfo")
        .child(currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        // onlineServicedata.id = (snap.snapshot.value as Map)["id"];
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: const EdgeInsets.only(top: 40),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: _markers,
            initialCameraPosition: googlePlexIntitialPosition,
            onMapCreated: (GoogleMapController mapContoller) {
              controllerGoogleMap = mapContoller;
              // mapContoller.setMapStyle(themeforMap);
              googleMapCompleteContoller.complete(mapContoller);
              locateServicePosition();

              setState(() {});
              // getCurrentLiveLocationOfUser();
            },
          ),
          // statusText != "Online"
          //     ? Container(
          //         height: MediaQuery.of(context).size.height,
          //         width: double.infinity,
          //         color: Colors.black87,
          //       )
          //     : Container(),
          // Positioned(
          //   top: statusText != "Online"
          //       ? MediaQuery.of(context).size.height * 0.05
          //       : 20,
          //   left: 0,
          //   right: 0,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       ElevatedButton(
          //         onPressed: () {
          //           if (isDriverActive != true) {
          //             serviceProviderOnline();
          //             // updateDriversLocationAtRealTime();

          //             setState(() {
          //               statusText = "Online";
          //               isDriverActive = true;
          //             });
          //           } else {
          //             serviceProviderOffline();
          //             setState(() {
          //               statusText = "Offline";
          //               isDriverActive = false;
          //             });
          //             Fluttertoast.showToast(msg: "You're offline");
          //           }
          //         },
          //         //   Fluttertoast.showToast(
          //         //       msg: "Please select a vehicle from above");
          //         // }
          //         // setState(() {
          //         //   searchNearestOnlineDrivers(selectedVehicleType);
          //         //   saveSelection();
          //         // });
          //         style: ElevatedButton.styleFrom(
          //             elevation: 0,
          //             fixedSize: const Size(200, 40),
          //             backgroundColor: Colors.grey,
          //             shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(26),
          //                 side: const BorderSide(style: BorderStyle.solid))),
          //         child: Text(
          //           isDriverActive ? "Online" : "Now Offline",
          //           style: const TextStyle(color: Colors.white, fontSize: 15),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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

  // updateDriversLocationAtRealTime() {
  //   streamSubscriptionPosition =
  //       Geolocator.getPositionStream().listen((Position position) {
  //     if (isDriverActive == true) {
  //       Geofire.setLocation(currentUser!.uid, serviceCurrentPosition!.latitude,
  //           serviceCurrentPosition!.longitude);
  //     }
  //     LatLng latLng = LatLng(
  //         serviceCurrentPosition!.latitude, serviceCurrentPosition!.longitude);

  //     controllerGoogleMap!.animateCamera(CameraUpdate.newLatLng(latLng));
  //   });
  // }

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

    Future.delayed(const Duration(milliseconds: 2000), () {
      SystemChannels.platform.invokeMethod("SystemNavigator.pop");
    });
  }

  // void dispose() {
  //   // Cancel the subscription to prevent
  //   retrieveServiceRequest(serviceType);

  //   super.dispose();
  // }
}
