import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_providers_glow/Assistants/assitant_method.dart';
// import 'package:service_providers_glow/Assistants/assistant_methods.dart';
import 'package:service_providers_glow/global/global.dart';
import 'package:service_providers_glow/models/directions_details_info.dart';
// import 'package:service_providers_glow/global/mapKey.dart';
import 'package:service_providers_glow/models/user_service_request.dart';

class UserLocation extends StatefulWidget {
  final UserServiceRequestInfo? userCurrentLocation;

  const UserLocation({super.key, required this.userCurrentLocation});

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  final Completer<GoogleMapController> googleMapCompleteController =
      Completer<GoogleMapController>();

  GoogleMapController? controllerGoogleMap;
  LatLng? userLocation;
  Map<PolylineId, Polyline> polylines = {};

  Timer? _timer;

  String distance = " ";
  String duration = " ";

  Future<void> _cameraPosition(LatLng pos) async {
    final GoogleMapController controller =
        await googleMapCompleteController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> locateServicePosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    serviceCurrentPosition = currentPosition;

    LatLng latLngPosition = LatLng(
        serviceCurrentPosition!.latitude, serviceCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);

    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            serviceCurrentPosition!, context);

    _updateDriverPosition(latLngPosition);
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You Have Arrived!',
            ),
            const SizedBox(height: 20),
            Text(
              'You are now at your destination.',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
                  position: driverPosition!,
                  icon: BitmapDescriptor.defaultMarker,
                ),
              if (widget.userCurrentLocation != null)
                Marker(
                  markerId: MarkerId(widget.userCurrentLocation!.userName),
                  position: widget.userCurrentLocation!.originLatLng,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                _showDestinationReachedModal();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 90, 228, 168)),
              child: Text(
                "Show Service Provider Info ",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
}
