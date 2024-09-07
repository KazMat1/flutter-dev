import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  late GoogleMapController mapController;

  Future<void> _loadCustomMarker() async {
    final BitmapDescriptor customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'images/soba.png',
    );

    setState(() {
      _markers.add(const Marker(
            markerId: MarkerId('Santiago'),
            position: LatLng(-33.488897, -70.669265)
      ));

      _markers.add(const Marker(
          markerId: MarkerId('Sydney'),
          position: LatLng(-33.86, 151.20),
      ));

      _markers.add(Marker(
          markerId: const MarkerId('custom_marker'),
          position: const LatLng(26.5916283, 127.9739272), // 任意の座標
          icon: customIcon,
      ));
    });
  }

  final LatLng _center = const LatLng(26.4874273, 127.5783151);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          mapType: MapType.hybrid, // 方位磁針
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 8.0,
          ),
          markers: _markers,
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: _goToTheLake,
            label: const Text('To the lake!'),
            icon: const Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    // final GoogleMapController controller = await mapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
