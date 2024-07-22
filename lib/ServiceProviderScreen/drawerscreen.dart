import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_providers_glow/ServiceProviderScreen/editprofile.dart';
import 'package:service_providers_glow/ServiceProviderScreen/userlogin.dart';
import 'package:service_providers_glow/global/global.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  Uint8List? _image;

  void _selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 50, 0, 20),
          child: Column(
            children: [
              Stack(
                children: [
                  _image != null
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: MemoryImage(_image!),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 55,
                            backgroundImage: NetworkImage(
                              "https://w7.pngwing.com/pngs/527/663/png-transparent-logo-person-user-person-icon-rectangle-photography-computer-wallpaper-thumbnail.png",
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: 1,
                    left: 56,
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
                            size: 25,
                            color: Color.fromARGB(255, 90, 228, 168),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                userModelCurrentInfo!.name!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              // StreamBuilder<QuerySnapshot>(
              //   stream: FirebaseFirestore.instance
              //       .collection('userInfo')
              //       .snapshots(),
              //   builder: (BuildContext context,
              //       AsyncSnapshot<QuerySnapshot> snapshot) {
              //     if (snapshot.hasError) {
              //       print('Error: ${snapshot.error}');
              //       return const Center(
              //         child: Text('Something went wrong'),
              //       );
              //     }

              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }

              //     QuerySnapshot querySnapshot = snapshot.data!;

              //     // Assuming you want to access the username of the first document
              //     DocumentSnapshot document = querySnapshot.docs.first;
              //     userName = document.get('Username');
              //     return Text(
              //       '$userName',
              //       style: const TextStyle(
              //           fontSize: 15, fontWeight: FontWeight.normal),
              //     );
              //   },
              // ),
              const SizedBox(
                height: 20,
              ),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(45, 34, 0, 26),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.black,
                            height: 40,
                            width: 40,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                size: 25,
                                color: Color.fromARGB(255, 90, 228, 168),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfile()));
                            },
                            child: const Text(
                              "Edit Profile",
                              style: TextStyle(fontSize: 15),
                            ),
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(45, 0, 0, 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.black,
                              height: 40,
                              width: 40,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.info_outline,
                                  size: 25,
                                  color: Color.fromARGB(255, 90, 228, 168),
                                  textDirection: TextDirection.ltr,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "UserInfo",
                              style: TextStyle(fontSize: 15),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(45, 26, 0, 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 40,
                              width: 40,
                              color: Colors.black,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.history,
                                  size: 25,
                                  color: Color.fromARGB(255, 90, 228, 168),
                                  textDirection: TextDirection.ltr,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                          child: Text(
                            "Trip History",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(45, 12, 0, 26),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.black,
                              height: 40,
                              width: 40,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserLogin()));
                                },
                                icon: const Icon(
                                  Icons.logout_outlined,
                                  size: 25,
                                  color: Color.fromARGB(255, 90, 228, 168),
                                  textDirection: TextDirection.ltr,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // FirebaseAuth.instance.signOut();
                            // showToast(message: "User Logged Out");
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const UserLogin(),
                            //   ),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(style: BorderStyle.none),
                            ),
                          ),
                          child: const Text(
                            "Log Out",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    }
  }
}
