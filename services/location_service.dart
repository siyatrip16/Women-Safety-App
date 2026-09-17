import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position?> getCurrentLocation() async {
    print('>>> Requesting permission...');
    bool hasPermission = await requestPermission();
    print('>>> Permission result: $hasPermission');
    if (!hasPermission) return null;

    try {
      print('>>> Getting location...');
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(const Duration(seconds: 10));
      print('>>> Got location: ${_currentPosition?.latitude}');
      notifyListeners();
      return _currentPosition;
    } catch (e) {
      print('>>> GPS failed: $e, trying last known...');
      _currentPosition = await Geolocator.getLastKnownPosition();
      print('>>> Last known: ${_currentPosition?.latitude}');
      notifyListeners();
      return _currentPosition;
    }
  }
  String getMapsLink(Position position) {
    return 'https://maps.google.com/?q=${position.latitude},${position.longitude}';
  }
}