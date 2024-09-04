// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_providers_glow/ServiceProviderScreen/Account.dart';
import 'package:service_providers_glow/ServiceProviderScreen/editprofile.dart';
import 'package:service_providers_glow/ServiceProviderScreen/history.dart';
import 'package:service_providers_glow/global/global.dart';
import 'package:service_providers_glow/tapPages/home_tab.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? tabController;

  int selectedIndex = 0;

  LocationPermission? _locationPermission;

  Color buttonColor = Colors.grey;

  String statusText = 'Offline';
  bool isServiceProviderActive = false;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  String themeforMap = "";
  final Completer<GoogleMapController> googleMapCompleteContoller =
      Completer<GoogleMapController>();

  GoogleMapController? controllerGoogleMap;

  Position? currentPositionOfUser;
  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context)
        .loadString('maps/standard_maps.json')
        .then((value) {
      themeforMap = value;
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Call showModalBottomSheet when the widget is built
    });

    tabController = TabController(length: 2, vsync: this);
  }

  getCurrentLiveLocationOfUser() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    currentPositionOfUser = positionOfUser;

    LatLng positionOfUserInLatLng = LatLng(
        currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: positionOfUserInLatLng, zoom: 15);
    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTab(),
          DrawerScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: "Account",
          ),
        ],
        unselectedItemColor: darkTheme ? Colors.grey : Colors.grey,
        selectedItemColor: darkTheme ? Colors.white : Colors.white,
        backgroundColor: darkTheme
            ? Color.fromARGB(255, 0, 29, 110)
            : Color.fromARGB(255, 0, 29, 110),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showSelectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
