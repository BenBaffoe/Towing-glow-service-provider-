// import 'dart:ui';

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:googleapis/datastore/v1.dart';
import 'package:service_providers_glow/ServiceProviderScreen/userLocation.dart';
import 'package:service_providers_glow/global/global.dart';
// import 'package:service_providers_glow/global/global.dart';
import 'package:service_providers_glow/models/user_service_request.dart';
// import 'package:service_providers_glow/tapPages/home_tab.dart';

class ServiceRequests extends StatefulWidget {
  // final Map<String, dynamic> payload;
  final String payload;
  // final Map payload_map;
  UserServiceRequestInfo? userServiceRequestInfo;

  ServiceRequests(
      {super.key, required this.payload, required this.userServiceRequestInfo});

  @override
  State<ServiceRequests> createState() => _ServiceRequestsState();
}

class _ServiceRequestsState extends State<ServiceRequests> {
  DatabaseReference? referenceRequest;

  String service = "";
  String name = "";
  String phone = "";
  String email = "";

  Future<void> serviceProviderInfo() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Ensure the user is logged in
      if (user == null) {
        print('No user is logged in.');
        return;
      }

      // Get the user's ID
      String uid = user.uid;

      // Reference to the user's data in the Realtime Database
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('userInfo').child(uid);

      // Retrieve the data
      DataSnapshot snapshot = await userRef.get();

      // Reference to push data into the "serviceProvider" node
      referenceRequest =
          FirebaseDatabase.instance.ref().child("serviceProvider").push();

      // Convert the snapshot to a Map
      if (snapshot.exists) {
        Map<dynamic, dynamic> serviceProviderInfoMap =
            snapshot.value as Map<dynamic, dynamic>;

        // Assuming the structure of the user info map is flat
        String service = serviceProviderInfoMap['service'];
        String name = serviceProviderInfoMap['name'];
        String phone = serviceProviderInfoMap['phone'];
        String email = serviceProviderInfoMap['email'];

        Map<String, dynamic> serviceInfo = {
          "email": email,
          "name": name,
          "phone": phone,
          "service": service,
          "location": driverPosition, // Make sure this variable is defined
        };

        print("$driverPosition + Hellooooooooooooooooooooooooooooooooooooooo");

        // Push the data to the "serviceProvider" node
        await referenceRequest!.set(serviceInfo);

        print("Data pushed to serviceProvider node successfully:");
        print("Reference: $referenceRequest");
        print("Service Info: $serviceInfo");
      } else {
        print('No data found for this user.');
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }

    print("$driverPosition + Hellooooooooooooooooooooooooooooooooooooooo");
  }

  // void drawPolyline() async {
  //   LatLng userLatLng = await locateServicePosition();
  //   print(
  //       'User\'s current position: ${userLatLng.latitude}, ${userLatLng.longitude}');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15.0, 30, 15, 15),
            child: Text(
              "Alert",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45),
            ),
          ),
          const Text(
            "Service Request",
            style: TextStyle(
              color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold,
              // shadows: [
              //   Shadow(
              //     blurRadius: 20,
              //     color: Colors.grey,
              //     offset: Offset(0.3, 0.4),
              //   )
              // ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        "assets/car-accident-road-displeased-driver-female-character-stand-roadside-with-broken-automobile-open-hood-steam_1016-9814.avif",

                        width: 380,
                        color: Colors
                            .black12, // Replace with your app's background color
                        colorBlendMode: BlendMode.srcATop,
                        // colorBlendMode:Colors.transparent ,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Text(
                        widget.userServiceRequestInfo!.userName,
                        // widget.payload,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          // shadows: [
                          //   Shadow(
                          //     blurRadius: 20.0,
                          //     color: Colors.grey,
                          //     offset: Offset(0.3, 1.0),
                          //   )
                          // ]),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          // print(serviceProviderInfo());
                          serviceProviderInfo();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserLocation(
                                    userCurrentLocation:
                                        widget.userServiceRequestInfo)),
                          );

                          // drawPolyline();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.green,
                          fixedSize: const Size(140, 50),
                          elevation: 1,
                        ),
                        child: const Text(
                          "Accept",
                          style: TextStyle(color: Colors.white),
                        )),
                    const SizedBox(
                      width: 80,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.red,
                          fixedSize: const Size(140, 50),
                          elevation: 1,
                        ),
                        child: const Text(
                          "Decline",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
