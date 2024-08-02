import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:service_providers_glow/ServiceProviderScreen/forgotpassword.dart';
import 'package:service_providers_glow/ServiceProviderScreen/signup.dart';
import 'package:service_providers_glow/ServiceProviderScreen/userhome.dart';
import 'package:service_providers_glow/global/global.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final formKey2 = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 0, 29, 110),
        title: const Text(
          "Towing Glow",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 29, 110),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 29, 110),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " Welcome",
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: const Color.fromARGB(255, 0, 29, 110),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Log In ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Expanded(
              child: Container(
                height: double.infinity,
                width: 410,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                  ),
                ),
                child: Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: Form(
                      key: formKey2,
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _emailController,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value)) {
                                    return "Please enter a valid email";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 245, 245, 245),
                                  filled: true,
                                  labelText: "Email",
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(14),
                                      )),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _passwordController,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                                          .hasMatch(value)) {
                                    return "at least 8 characters,must have numeric or special characters";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 245, 245, 245),
                                  filled: true,
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(14),
                                      )),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    14, 4.0, 12.0, 0.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Forgotpassword()));
                                  },
                                  child: const Text(
                                    "Forgot password ?",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color.fromARGB(
                                          255, 0, 156, 222),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(30, 60),
                                  elevation: 2,
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 29, 110),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 5,
                                    )
                                  : const Text(
                                      " Log In ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Center(
                            child: Text(
                              'Create have an account ?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(1.0, 0, 0, 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const SignUp()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 156, 222),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//   void _signIn() async {
//     setState(() => isLoading = true);

//     if (formKey2.currentState!.validate()) {
//       try {
//         String email = _emailController.text;
//         String password = _passwordController.text;
//         await Future.delayed(const Duration(seconds: 3));

//         User? user = await _auth.signInWithEmailAndPassword(email, password);

//         if (user != null) {
//           showToast(message: "User Login Sucessful");
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const Userhome()),
//           );
//         } else {
//           null;
//         }
//       } catch (e) {
//         showToast(message: "Error signing in: $e");
//       }
//     }
//     setState(() => isLoading = false);
//   }

  void _submit() async {
    if (formKey2.currentState!.validate()) {
      await firebaseAuth
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((auth) async {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child("userInfo");

        userRef.child(firebaseAuth.currentUser!.uid).once().then((value) async {
          final snap = value.snapshot;
          if (snap.value != null) {
            currentUser = auth.user;

            await Fluttertoast.showToast(msg: "Login Successful");
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => const Home()));
          } else {
            await Fluttertoast.showToast(msg: "No record exists");
            firebaseAuth.signOut();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => const UserLogin()));
          }
        });
      }).catchError((err) {
        Fluttertoast.showToast(msg: "Error: " + err.message);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Some inputs in the text field are not valid");
    }
  }
}
