import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_providers_glow/Assistants/assitant_method.dart';
// import 'package:service_providers_glow/Assistants/assistant_methods.dart';
import 'package:service_providers_glow/global/global.dart';
import 'package:service_providers_glow/local_notifications.dart';
import 'package:service_providers_glow/models/directions_details_info.dart';
// import 'package:service_providers_glow/global/mapKey.dart';
import 'package:service_providers_glow/models/user_service_request.dart';
import 'package:service_providers_glow/paystack/paymnetstats.dart';

class UserLocation extends StatefulWidget {
  final UserServiceRequestInfo? userCurrentLocation;

  const UserLocation({super.key, required this.userCurrentLocation});

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  final Completer<GoogleMapController> googleMapCompleteController =
      Completer<GoogleMapController>();

  Paymentstats? payService;

  String amount = "50";

  Future<void> PaymentstatsSent() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('No user is logged in.');
        return;
      }

      String uid = user.uid;
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('userInfo').child(uid);

      // Fetching user data
      DataSnapshot snapshot = await userRef.get();
      DatabaseReference referenceRequest =
          FirebaseDatabase.instance.ref().child("paymentStatus").push();

      if (snapshot.exists) {
        Map<dynamic, dynamic> serviceProviderInfoMap =
            snapshot.value as Map<dynamic, dynamic>;

        String service = serviceProviderInfoMap['service'];
        String name = serviceProviderInfoMap['name'];
        String phone = serviceProviderInfoMap['phone'];
        String email = serviceProviderInfoMap['email'];
        String time = serviceProviderInfoMap['time'];

        Map<String, dynamic> serviceInfo = {
          "email": email,
          "name": name,
          "phone": phone,
          "service": service,
          "JobStatus": jobState,
          "time": time,
          "amount": amount,
        };

        // Creating Paymentstats object
        payService = Paymentstats(
          name: name,
          phone: phone,
          service: service,
          jobState: jobState,
          time: time,
          amount: amount,
        );

        // Pushing data to Firebase
        await referenceRequest.set(serviceInfo);

        print("Data pushed to paymentStatus node successfully:");
        print("Reference: $referenceRequest");
        print("Service Info: $serviceInfo");
      } else {
        print('No data found for this user.');
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }

  GoogleMapController? controllerGoogleMap;
  LatLng? userLocation;
  Map<PolylineId, Polyline> polylines = {};

  Timer? _timer;

  String jobState = '';

  String distance = " ";
  String duration = " ";

  Future<void> _cameraPosition(LatLng pos) async {
    final GoogleMapController controller =
        await googleMapCompleteController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  locateServicePosition() async {
    try {
      // Check if we have location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("Location permission denied");
        return;
      }

      // Attempt to get the current position
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng latLngPosition =
          LatLng(currentPosition.latitude, currentPosition.longitude);

      serviceProviderLocation = latLngPosition;

      if (controllerGoogleMap != null) {
        CameraPosition cameraPosition =
            CameraPosition(target: latLngPosition, zoom: 15);
        controllerGoogleMap!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        String humanReadableAddress =
            await AssistantMethods.searchAddressForGeographicCoOrdinates(
                currentPosition, context);

        _updateDriverPosition(latLngPosition);
      } else {
        print("Google Map Controller is null when trying to animate camera.");
      }
    } catch (e) {
      print("Error while retrieving the service provider's location: $e");
    }
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    userLocation = widget.userCurrentLocation!.originLatLng;

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googlesMapKey,
      PointLatLng(driverPosition!.latitude, driverPosition!.longitude),
      PointLatLng(userLocation!.latitude, userLocation!.longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }

    return polylineCoordinates;
  }

  void _updateDriverPosition(LatLng position) {
    setState(() {
      driverPosition = position;
      // serviceProviderLocation = driverPosition;
      _cameraPosition(driverPosition!);
    });
  }

  void _handleSameLocation() {
    if (driverPosition != null &&
        serviceProviderLocation != null &&
        driverPosition!.latitude == serviceProviderLocation!.latitude &&
        driverPosition!.longitude == serviceProviderLocation!.longitude) {
      // Show notification if the locations are the same

      // Add a small offset to service provider's location to prevent repeated notifications
      serviceProviderLocation = LatLng(
        serviceProviderLocation!.latitude + 0.001,
        serviceProviderLocation!.longitude + 0.001,
      );
    }
  }

  Future<void> _getDistanceAndTime() async {
    if (widget.userCurrentLocation != null &&
        widget.userCurrentLocation!.originLatLng != null) {
      serviceProviderLocation = widget.userCurrentLocation!.originLatLng;
    } else {
      print("Service provider info or location is null");
    }

    print("Service Provider Location: $serviceProviderLocation");
    print("Driver Position: $driverPosition");

    if (serviceProviderLocation != null && driverPosition != null) {
      _handleSameLocation();

      DirectionsDetailsInfo? directions =
          await AssistantMethods.obtainOriginToDestinationDirectionsDetails(
        driverPosition!,
        serviceProviderLocation!,
      );

      if (directions != null) {
        setState(() {
          distance = directions.distanceText!;
          duration = directions.durationText!;
        });

        print('Distance: $distance, Duration: $duration');

        // Check if the duration is approximately 1 minute
        if (directions.durationValue != null &&
            directions.durationValue! <= 55 &&
            directions.durationValue! <= 65) {}
      } else {
        setState(() {
          distance = 'N/A';
          duration = 'N/A';
        });
        print('Directions not available');
      }

      print('Driver Position: $driverPosition');
      print('Service Provider Location: $serviceProviderLocation');
    } else {
      print("Driver position or Service provider location is null");
    }
  }

  void _showDestinationReachedModal() {
    _getDistanceAndTime();
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        width: double.infinity,
        height: 250,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                'Job Done ?',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                'User can make payment through the app!',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                "Note Payment records are recorded in the payment section.",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'User is to pay: GHS 50',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                PaymentstatsSent();
                setState(() {
                  jobState = "Done";
                });
                setState(() {});
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
              ),
              child: const Text(
                'Click here to enable user to make payment',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  @override
  void initState() {
    super.initState();

    locateServicePosition().then((_) {
      // _getDistanceAndTime();
      getPolylinePoints().then((coordinates) {
        if (coordinates.isNotEmpty) {
          generatePolylineFromPoints(coordinates);
        }
      });
    });
  }

  LatLng googlePlexInitialPosition =
      LatLng(37.43296265331129, -122.08832357078792);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: const EdgeInsets.only(top: 40),
            mapType: MapType.normal,
            myLocationEnabled: true,
            markers: {
              if (driverPosition != null)
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  position: googlePlexInitialPosition,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                ),
              if (widget.userCurrentLocation != null)
                Marker(
                  markerId: MarkerId(widget.userCurrentLocation!.userName),
                  position: widget.userCurrentLocation!.originLatLng,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
            },
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: CameraPosition(
              target: googlePlexInitialPosition,
              zoom: 10,
            ),
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              googleMapCompleteController.complete(mapController);
              locateServicePosition();
            },
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(45),
                child: Container(
                  height: 90,
                  width: 90,
                  child: FloatingActionButton(
                    onPressed: () {
                      _showDestinationReachedModal();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.monetization_on,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    elevation: 2,
                    backgroundColor: const Color.fromARGB(255, 0, 156, 222),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   _timer?.cancel(); // Cancel the timer when the widget is disposed
  //   super.dispose();
  // }
}
