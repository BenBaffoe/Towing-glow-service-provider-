import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_providers_glow/Common/toast.dart';
import 'package:service_providers_glow/global/global.dart';
import 'package:service_providers_glow/models/user_service_request.dart';
import 'package:service_providers_glow/pushnotification/notification_dialog_box.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) => {
              if (remoteMessage != null)
                {
                  readUserServiceRequestInfo(
                      remoteMessage.data['serviceID'], context)
                }
            });

    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      readUserServiceRequestInfo(remoteMessage!.data['serviceID'], context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      readUserServiceRequestInfo(remoteMessage!.data['serviceID'], context);
    });
  }

  readUserServiceRequestInfo(String serviceID, BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("Service Requests")
        .child("serviceID")
        .onValue
        .listen((event) {
      if (event.snapshot.value == 'waiting' ||
          event.snapshot.value == firebaseAuth.currentUser!.uid) {
        FirebaseDatabase.instance
            .ref()
            .child("Service Requests")
            .child(serviceID)
            .once()
            .then((snapData) {
          if (snapData.snapshot.value != null) {
            audioPlayer.open(Audio("music/music_notification.mp3"));
            audioPlayer.play();

            double originLat = double.parse(
                (snapData.snapshot.value! as Map)["origin"]["latitude"]);
            double originLng = double.parse(
                (snapData.snapshot.value! as Map)["origin"]["longitude"]);
            String originAddress =
                (snapData.snapshot.value! as Map)["originAddress"];

            double destinationLat = double.parse(
                (snapData.snapshot.value! as Map)["destination"]["latitude"]);
            double destinationLng = double.parse(
                (snapData.snapshot.value! as Map)["destination"]["longitude"]);
            String destinationAddress =
                (snapData.snapshot.value! as Map)["destinationAddress"];

            String userName = (snapData.snapshot.value! as Map)["userName"];
            String userPhone = (snapData.snapshot.value! as Map)["userPhone"];

            String? serviceID = snapData.snapshot.key;

            UserServiceRequestInfo userServiceRequestInfo =
                UserServiceRequestInfo();

            userServiceRequestInfo.originLatLng = LatLng(originLat, originLng);
            userServiceRequestInfo.originAddress = originAddress;
            userServiceRequestInfo.destinationLatLng =
                LatLng(destinationLat, destinationLng);
            userServiceRequestInfo.destinationAddress = destinationAddress;
            userServiceRequestInfo.userName = userName;
            userServiceRequestInfo.userPhone = userPhone;

            userServiceRequestInfo.serviceID = serviceID;

            showDialog(
                context: context,
                builder: (BuildContext context) => NotificationDialogBox(
                      userServiceRequestInfo: userServiceRequestInfo,
                    ));
          } else {
            Fluttertoast.showToast(
                msg: "This Service Request is not available");
          }
        });
      } else {
        Fluttertoast.showToast(msg: "This Service Request was cancelled");
        Navigator.pop(context);
      }
    });
  }

  Future generateAndGetToken() async {
    String? resgistionToken = await messaging.getToken();
    print("FCM registration token:  + ${resgistionToken}");

    FirebaseDatabase.instance
        .ref()
        .child("Service Providers")
        .child(firebaseAuth.currentUser!.uid)
        .child('token')
        .set(resgistionToken);

    messaging.subscribeToTopic("allServiceProviders");
    messaging.subscribeToTopic("allUsers");
  }
}
