import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

enum LocationSettingResult {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  enabled,
}

class _MyAppState extends State<MyApp> {
  final Set<Marker> _markers = {};
  CameraPosition? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _initLocationService();
    _setInitialLocation();
  }

  late GoogleMapController mapController;

  Future<void> _loadCustomMarker() async {
    final BitmapDescriptor customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(200, 200)),
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
          position: const LatLng(26.6021631, 127.9855404), // 任意の座標
          icon: customIcon,
      ));
    });
  }

  Future<void> _setInitialLocation() async {
    final LatLng currentLocation = await getCurrentLocation();
    setState(() {
      _currentPosition = CameraPosition(
        bearing: 192.8334901395799,
        target: currentLocation,
        tilt: 59.440717697143555,
        zoom: 20,
      );
    });
  }


  final LatLng _center = const LatLng(26.4874273, 127.5783151);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<LatLng> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Awesome Map Viewer'),
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
          onPressed: _goToTheCurrentLocation,
          label: const Text('現在地へGo!'),
          icon: const Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  Future<void> _goToTheCurrentLocation() async {
    // final GoogleMapController controller = await mapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(_currentPosition!));
  }

  Future<void> _initLocationService() async {
    final locationResult = await checkLocationSetting();
    await recoverLocationSettings(context, locationResult);
  }

  // 位置情報に関するパーミションを取得するメソッド
  Future<LocationSettingResult> checkLocationSetting() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.value(LocationSettingResult.serviceDisabled);
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.value(LocationSettingResult.permissionDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.value(LocationSettingResult.permissionDeniedForever);
    }
    return Future.value(LocationSettingResult.enabled);
  }

  // 位置情報を許可してもらうようにまた表示する
  Future<void> recoverLocationSettings(
      BuildContext context, LocationSettingResult locationResult) async {
    if (locationResult == LocationSettingResult.enabled) {
      return;
    }
    final result = await showOkCancelAlertDialog(
      context: context,
      okLabel: 'OK',
      cancelLabel: 'キャンセル',
      title: 'xxxxxxx',
      message: 'xxxxxxxxxxxx',
    );
    if (result == OkCancelResult.cancel) {
        // キャンセルされた時の処理
    } else {
      // 許可の状況に応じて、設定を開いて許可してもらう
      locationResult == LocationSettingResult.serviceDisabled
          ? await Geolocator.openLocationSettings()
          : await Geolocator.openAppSettings();
    }
  }


}
