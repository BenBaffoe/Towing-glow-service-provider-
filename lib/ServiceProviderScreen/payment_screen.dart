import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:service_providers_glow/ServiceProviderScreen/paymentscreen.dart';
import 'package:service_providers_glow/ServiceProviderScreen/paymodel.dart';
import 'package:service_providers_glow/global/global.dart';

class Payment_Screen extends StatefulWidget {
  const Payment_Screen({super.key});

  @override
  State<Payment_Screen> createState() => _Payment_ScreenState();
}

class _Payment_ScreenState extends State<Payment_Screen> {
  Paymodel? _paymodel;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userId;
  String? service;
  String? payConfirmed;
  bool isloading = false;

  // Future<void> confirmPayment() async {
  //   DatabaseReference referenceRequest =
  //       FirebaseDatabase.instance.ref().child("paymentStatus").push();

  //   DatabaseReference userRef =
  //       FirebaseDatabase.instance.ref().child("userInfo");

  //   // Get user data from Firebase
  //   userRef.child(firebaseAuth.currentUser!.uid).onValue.listen((event) {
  //     if (event.snapshot.value != null) {
  //       Map<String, dynamic> userData =
  //           Map<String, dynamic>.from(event.snapshot.value as Map);
  //       userName = userData['name'] ?? '';
  //       userEmail = userData['email'] ?? '';
  //       userPhone = userData['phone'] ?? '';
  //       userId = userData['id'] ?? '';
  //       service = userData['service'] ?? '';

  //       Map userPaymnetInfo = {
  //         "name": userName,
  //         "email": userEmail,
  //         "phone": userPhone,
  //         "id": userId,
  //         "service": service,
  //         "amount": _paymodel?.amount,
  //         "time": _paymodel?.time,
  //         "payment": payConfirmed,
  //       };
  //       referenceRequest.set(userPaymnetInfo);
  //     }
  //   });
  // }

  Future<void> retrievePaymentStats() async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("paymentStatus");

    userRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> serviceRequestsMap =
            Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        serviceRequestsMap.forEach((key, value) {
          Map<dynamic, dynamic> serviceProviderInfo =
              Map<dynamic, dynamic>.from(value as Map<dynamic, dynamic>);

          String? service = serviceProviderInfo['service'] as String?;
          String? name = serviceProviderInfo['name'] as String?;
          String? phone = serviceProviderInfo['phone'] as String?;
          String? payment = serviceProviderInfo['payment'] as String?;
          String? amount = serviceProviderInfo['amount'] as String?;
          String? time = serviceProviderInfo['time'] as String?;

          if (payment == "Yes") {
            setState(() {
              _paymodel = Paymodel(
                  name: name,
                  service: service,
                  phone: phone,
                  amount: amount,
                  time: time);
              print('Updated Paymodel: $_paymodel'); // Debug print
            });
          }
        });
      } else {
        print('Snapshot does not exist');
      }
    }).onError((error) {
      print('Error: $error'); // Debug print for errors
    });
  }

  @override
  void initState() {
    super.initState();
    retrievePaymentStats();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios_new)),
          title: Text(
            "Payments",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 30, 8, 8),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 10, 0, 0),
                            child:
                                Text("Name: ${_paymodel?.name ?? 'No name'}"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                            child: Text(
                                "Phone: 0${_paymodel?.phone ?? 'No phone'}"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                            child: Text(
                                "Service: ${_paymodel?.service ?? 'No service'}"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                            child: Text(
                                "Amount: ${_paymodel?.amount ?? 'No service'}"),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                child: Text(
                                    "Service: ${_paymodel?.time ?? 'No service'}"),
                              ),
                            ],
                          ),
                          // GestureDetector(
                          //   onTap: () async {
                          //     setState(() {
                          //       payConfirmed = "Yes";
                          //       isloading = true;
                          //     });
                          //     setState(() {});
                          //     Future.delayed(
                          //       Duration(
                          //         seconds: 5,
                          //       ),
                          //       () => setState(() {
                          //         isloading = false;
                          //       }),
                          //     );
                          //     // confirmPayment();

                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 const Paymentscreen()));
                          //   },
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: isloading
                          //         ? const CircularProgressIndicator(
                          //             strokeWidth: 2,
                          //           )
                          //         : const Text(
                          //             "Make payment",
                          //             style: TextStyle(
                          //               color: Colors.blue,
                          //               fontWeight: FontWeight.w400,
                          //             ),
                          //           ),
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
