import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_providers_glow/Assistants/assitant_method.dart';

import 'package:service_providers_glow/global/global.dart';
import 'package:service_providers_glow/local_notifications.dart';
import 'package:service_providers_glow/pushnotification/notification_dialog_box.dart';
import 'package:service_providers_glow/pushnotification/push_notification_system.dart';
import 'package:service_providers_glow/tapPages/servicerequests.dart';
// import 'package:service_providers_glow/lib/models/pushdialog.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final Completer<GoogleMapController> googleMapCompleteContoller =
      Completer<GoogleMapController>();

  GoogleMapController? controllerGoogleMap;

  // Future<void> retrieveServiceRequest(String serviceType) async {
  //   DatabaseReference userRef =
  //       FirebaseDatabase.instance.ref().child("Service Requests");

  //   userRef.onValue.listen((event) {
  //     // Check if there's data
  //     if (event.snapshot.exists) {
  //       // Get the data as a Map
  //       Map<String, dynamic> serviceRequestsMap =
  //           Map<String, dynamic>.from(event.snapshot.value as Map);

  //       // Access the 'service' field
  //       String? service = serviceRequestsMap['service'] as String?;

  //       print(
  //           "$service + Aaaahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhaha");

  //       if (service != null && serviceType == service) {
  //         Map<String, dynamic> serviceRequestsInfo =
  //             Map<String, dynamic>.from(event.snapshot.value as Map);

  //         String origin = serviceRequestsInfo['origin'] ?? 'Unknown';
  //         String time = serviceRequestsInfo['time'] ?? 'Unknown';
  //         String userName = serviceRequestsInfo['userName'] ?? 'Unknown';
  //         String originAddress =
  //             serviceRequestsInfo['originAddress'] ?? 'Unknown';
  //         String userPhone = serviceRequestsInfo['userPhone'] ?? 'Unknown';

  //         Map<String, String> body = {
  //           'UserLocation': originAddress,
  //           'UserName': userName,
  //           'userPhone': userPhone,
  //           'service': service,
  //         };

  //         print(
  //           "$userName , $userPhone   ,  The programming I've stoppedddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
  //         );

  //         LocalNotifications.showNotificaion(
  //             title: 'Service Request',
  //             body: 'Service request from $userName',
  //             payload: "$userName requesting $service");

  //         // Uncomment if you want to show a dialog with service request details
  //         // showDialogWithServiceRequest(
  //         //     context, service, userName, userPhone, originAddress, time);
  //       }
  //     }
  //   });
  // }

  getNotification() {
    print("Listening for notifications");
    LocalNotifications.onClickedNotification.stream.listen((event) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ServiceRequests(payload: event)));
    });
  }

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
            String origin =
                serviceRequestInfo['origin']['latitude'].toString() +
                    ', ' +
                    serviceRequestInfo['origin']['longitude'].toString();
            String time = serviceRequestInfo['time'] ?? 'Unknown';
            String userName = serviceRequestInfo['userName'] ?? 'Unknown';
            String originAddress =
                serviceRequestInfo['originAddress'] ?? 'Unknown';
            String userPhone = serviceRequestInfo['userPhone'] ?? 'Unknown';

            originAddress.substring(0, 20);

            LocalNotifications.showSimpleNotification(
                title: 'Service Request',
                body: 'Service request from $userName',
                payload:
                    " \nName: $userName\nContact: 0$userPhone\nLocation: $originAddress\nService Request:  $service needed");
          }
        });
      }
    });
  }

//   Future<void> retrieveServiceRequest(String serviceType) async {
//   DatabaseReference userRef =
//       FirebaseDatabase.instance.ref().child("Service Requests");

//   userRef.onValue.listen((event) {
//     // Check if there's data
//     if (event.snapshot.exists) {
//       // Get the data as a Map
//       Map<dynamic, dynamic> serviceRequestsMap =
//           Map<dynamic, dynamic>.from(event.snapshot.value as Map);

//       // Iterate over the service requests
//       serviceRequestsMap.forEach((key, value) {
//         // Access the 'service' field
//         Map<dynamic, dynamic> serviceRequestInfo =
//             value as Map<dynamic, dynamic>;
//         String? service = serviceRequestInfo['service'] as String?;

//         print("$service + servicessssssssssssssssssssssssssssssssssssss");

//         if (service != null && serviceType == service) {
//           // Retrieve the service request info
//           String origin =
//               serviceRequestInfo['origin']['latitude'].toString() +
//                   ', ' +
//                   serviceRequestInfo['origin']['longitude'].toString();
//           String time = serviceRequestInfo['time'] ?? 'Unknown';
//           String userName = serviceRequestInfo['userName'] ?? 'Unknown';
//           String originAddress =
//               serviceRequestInfo['originAddress'] ?? 'Unknown';
//           String userPhone = serviceRequestInfo['userPhone'] ?? 'Unknown';

//           LocalNotifications.showNotificaion(
//               title: 'Service Request',
//               body: 'Service request from $userName',
//               payload: "$userName requesting $service");

//           // Show the dialog box
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('Service Request'),
//               content: Text('Service request from $userName'),
//               actions: [
//                 ElevatedButton(
//                   child: Text('Accept'),
//                   onPressed: () {
//                     // Handle accept button press
//                     print('Accept button pressed');
//                     // You can add your logic here to handle the accept button press
//                   },
//                 ),
//                 ElevatedButton(
//                   child: Text('Decline'),
//                   onPressed: () {
//                     // Handle decline button press
//                     print('Decline button pressed');
//                     // You can add your logic here to handle the decline button press
//                   },
//                 ),
//               ],
//             ),
//           );
//         }
//       });
//     }
//   });
// }

  void startPeriodicServiceRequestRetrieval() {
    // Define the timer duration
    const duration = Duration(seconds: 30);

    // Set up a timer that triggers every 'duration'
    Timer.periodic(duration, (Timer timer) {
      // Call your existing data retrieval function
      retrieveServiceRequest("Vulcanizer");
    });
  }

  // void showDialogWithServiceRequest(BuildContext context, String service,
  //     String userName, String userPhone, String originAddress) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('New Service Request'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Service: $service'),
  //               Text('Requested by: $userName'),
  //               Text('Phone: $userPhone'),
  //               Text('Origin Address: $originAddress'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Accept'),
  //             onPressed: () {
  //               // Handle accept action here
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text('Decline'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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

    serviceProviderLocation = humanReadableAddress;
  }

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
    LocalNotifications.init();
    checkLocationPermission();
    readCurrentDriverPermission();
    startPeriodicServiceRequestRetrieval();
    // PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    // pushNotificationSystem.initializeCloudMessaging(context);
    // pushNotificationSystem.generateAndGetToken();
    getNotification();
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
          Positioned(
            top: 80,
            left: 40,
            child: ElevatedButton(
              onPressed: () {
                retrieveServiceRequest("Towing Emergency");
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 20), elevation: 1),
              child: const Text("Press"),
            ),
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
                ? MediaQuery.of(context).size.height * 0.05
                : 20,
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

  // void dispose() {
  //   // Cancel the subscription to prevent
  //   retrieveServiceRequest(serviceType);

  //   super.dispose();
  // }
}
