import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
}

void permissionHandler() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.notification,
  ].request();
  print(statuses[Permission.location]);
  print(statuses[Permission.notification]);
  if (await Permission.location.status.isDenied ||
      await Permission.location.status.isDenied) {
    await openAppSettings();
  }
}

Future<String> getDeviceToken() async {
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission();
  }
  final deviceToken = await FirebaseMessaging.instance.getToken();
  print(deviceToken);
  if (deviceToken != null) {
    return deviceToken;
  }
  return '';
}

Future<Placemark> getUserAddress({
  required double latitude,
  required double longitude,
}) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
    latitude,
    longitude,
  );
  Placemark place = placemarks[0];

  return place;
}

Future<Position> getUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      permission = await Geolocator.requestPermission();
    }
  }
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
