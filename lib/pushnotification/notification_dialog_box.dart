// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:service_providers_glow/Assistants/assitant_method.dart';
// import 'package:service_providers_glow/global/global.dart';
// import 'package:service_providers_glow/models/user_service_request.dart';

// class NotificationDialogBox extends StatefulWidget {
//   UserServiceRequestInfo? userServiceRequestInfo;

//   NotificationDialogBox({this.userServiceRequestInfo});

//   @override
//   State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
// }

// class _NotificationDialogBoxState extends State<NotificationDialogBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24),
//       ),
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       child: Container(
//         margin: EdgeInsets.all(8),
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white,
//         ),
//         child: Column(
//           children: [
//             Image.asset('assets/towing-concept-illustration_114360-5474.jpg',
//                 height: 100, width: 100),
//             const SizedBox(
//               height: 10,
//             ),
//             const Text(
//               "New Service Request",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: Colors.black54),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             const Divider(
//               height: 2,
//               thickness: 2,
//               color: Colors.black54,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset(
//                         'assets/loca_2.png',
//                         width: 30,
//                         height: 30,
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Expanded(
//                         child: Container(
//                           child: Text(
//                             widget.userServiceRequestInfo!.originAddress!,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.amber,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     children: [Image.asset("")],
//                   ),
//                   Expanded(
//                     child: Text(
//                       widget.userServiceRequestInfo!.originAddress!,
//                       style: TextStyle(
//                         fontSize: 15,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             const Divider(
//               height: 2,
//               thickness: 2,
//               color: Colors.amber,
//             ),
//             Padding(
//               padding: EdgeInsets.all(20),
//               child: Row(
//                 children: [
//                   ElevatedButton(
//                       onPressed: () {
//                         audioPlayer.pause();
//                         audioPlayer.stop();
//                         audioPlayer = AssetsAudioPlayer();
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.red,
//                       ),
//                       child: const Text(
//                         'Cancel',
//                         style: TextStyle(
//                           fontSize: 15,
//                         ),
//                       )),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   ElevatedButton(
//                       onPressed: () {
//                         audioPlayer.pause();
//                         audioPlayer.stop();
//                         audioPlayer = AssetsAudioPlayer();

//                         acceptServiceRequest(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.green),
//                       child: const Text(
//                         "Accept",
//                         style: TextStyle(
//                           fontSize: 15,
//                         ),
//                       ))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   acceptServiceRequest(BuildContext context) {
//     FirebaseDatabase.instance
//         .ref()
//         .child("Service Providers")
//         .child(firebaseAuth.currentUser!.uid)
//         .child("newServiceStatus")
//         .once()
//         .then((snap) {
//       if (snap.snapshot.value == "idle") {
//         FirebaseDatabase.instance
//             .ref()
//             .child("Service Providers")
//             .child(firebaseAuth.currentUser!.uid)
//             .child("newServiceStatus")
//             .set("accepted");

//         AssistantMethods.pauseLiveLocationUpdate();

//         // Navigator.push(context , MaterialPageRoute(builder: (c)=> NewServiceScreen()))
//       } else {
//         Fluttertoast.showToast(msg: "This Service Request is not available");
//       }
//     });
//   }
// }
