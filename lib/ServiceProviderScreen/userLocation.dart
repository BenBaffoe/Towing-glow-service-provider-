import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_providers_glow/Assistants/assitant_method.dart';
// import 'package:service_providers_glow/Assistants/assistant_methods.dart';
import 'package:service_providers_glow/global/global.dart';
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
        ],
      ),
    );
  }
}
