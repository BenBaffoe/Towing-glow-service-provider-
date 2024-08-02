import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_providers_glow/Common/toast.dart';
import 'package:service_providers_glow/ServiceProviderScreen/editprofile.dart';
import 'package:service_providers_glow/ServiceProviderScreen/history.dart';
import 'package:service_providers_glow/ServiceProviderScreen/historyinformation.dart';
import 'package:service_providers_glow/ServiceProviderScreen/userlogin.dart';

class DrawerScreen extends StatefulWidget {
  DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  Uint8List? _image;
  Historyinfo? usersInfo;
  String? profilePhoto;

  @override
  void initState() {
    super.initState();
    getPhoto();
    retrieveUserData();
  }

  retrieveUserData() async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("userInfo");

    userRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        setState(() {
          usersInfo = Historyinfo(
            userName: userData['name'] ?? '',
            userEmail: userData['email'] ?? '',
            userPhone: userData['phone'] ?? '',
            service: userData['service'] ?? '',
            userLocation: userData['originAddress'] ?? '',
          );
        });
      }
    });
  }

  Future<void> getPhoto() async {
    profilePhoto = await FirebaseStorage.instance
        .ref()
        .child('profile/avatar.png')
        .getDownloadURL();

    setState(() {});
  }

  void _selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Account Info",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
      ),
      body: FutureBuilder(
        future: retrieveUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (usersInfo == null) {
            return const Center(
              child: Text("No user data available"),
            );
          }

          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          profilePhoto != null
                              ? Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: CircleAvatar(
                                    radius: 65,
                                    backgroundImage:
                                        NetworkImage(profilePhoto!),
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 65,
                                    backgroundImage: NetworkImage(
                                      "https://w7.pngwing.com/pngs/527/663/png-transparent-logo-person-user-person-icon-rectangle-photography-computer-wallpaper-thumbnail.png",
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            width: 200,
                          ),
                          Positioned(
                            bottom: 1,
                            left: 106,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: Colors.black,
                                height: 50,
                                width: 50,
                                child: IconButton(
                                  onPressed: _selectImage,
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Text(
                            "${usersInfo!.userName!}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 34, 0, 26),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 25,
                                        color: Colors.blue,
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditProfile(
                                              userHistory: usersInfo,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 26, 0, 20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.history,
                                          size: 30,
                                          color: Colors.blue,
                                          textDirection: TextDirection.ltr,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HistoryInformation(
                                              userHistory: usersInfo,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Service History",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 20, 0, 26),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const UserLogin(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.logout_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                            textDirection: TextDirection.ltr,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _signOut();
                                      },
                                      child: const Text(
                                        "Log Out",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _signOut() async {
    FirebaseAuth.instance.signOut();
    showToast(message: "User Logged Out");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const UserLogin()));
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
  }
}
