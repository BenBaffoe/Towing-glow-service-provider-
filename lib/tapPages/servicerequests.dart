import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:service_providers_glow/ServiceProviderScreen/userLocation.dart';
import 'package:service_providers_glow/global/global.dart';
import 'package:service_providers_glow/models/serviceproviderdata.dart';
import 'package:service_providers_glow/models/user_service_request.dart';

class ServiceRequests extends StatefulWidget {
  final String payload;
  final UserServiceRequestInfo? userServiceRequestInfo;

  ServiceRequests({
    super.key,
    required this.payload,
    required this.userServiceRequestInfo,
  });

  @override
  State<ServiceRequests> createState() => _ServiceRequestsState();
}

class _ServiceRequestsState extends State<ServiceRequests> {
  DatabaseReference? referenceRequest;
  // ServiceData? serviceData;

  Future<void> serviceProviderInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('No user is logged in.');
        return;
      }

      Map originLocationMap = {
        "latitude":
            widget.userServiceRequestInfo?.serviceProviderLocation['latitude'],
        "longitude":
            widget.userServiceRequestInfo?.serviceProviderLocation['longitude'],
      };

      String uid = user.uid;
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('userInfo').child(uid);

      DataSnapshot snapshot = await userRef.get();
      referenceRequest =
          FirebaseDatabase.instance.ref().child("serviceProvider").push();

      if (snapshot.exists) {
        Map<dynamic, dynamic> serviceProviderInfoMap =
            snapshot.value as Map<dynamic, dynamic>;

        String service = serviceProviderInfoMap['service'];
        String name = serviceProviderInfoMap['name'];
        String phone = serviceProviderInfoMap['phone'];
        String email = serviceProviderInfoMap['email'];

        Map<String, dynamic> serviceInfo = {
          "email": email,
          "name": name,
          "phone": phone,
          "service": service,
          "location": originLocationMap,
        };

        serviceData = ServiceData(name: name, phone: phone, serrvice: service);

        print(
            "${widget.userServiceRequestInfo?.serviceProviderLocation} + Hellooooooooooooooooooooooooooooooooooooooo");

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

    print(
        "${widget.userServiceRequestInfo?.serviceProviderLocation} + Hellooooooooooooooooooooooooooooooooooooooo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
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
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 30),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        "assets/car-accident-road-displeased-driver-female-character-stand-roadside-with-broken-automobile-open-hood-steam_1016-9814.avif",
                        width: 380,
                        color: Colors.black12,
                        colorBlendMode: BlendMode.srcATop,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Text(
                        widget.userServiceRequestInfo?.userName ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        serviceProviderInfo();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserLocation(
                              userCurrentLocation:
                                  widget.userServiceRequestInfo,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.green,
                        fixedSize: const Size(140, 50),
                        elevation: 1,
                      ),
                      child: const Text("Accept",
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 80),
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
                      child: const Text("Decline",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
