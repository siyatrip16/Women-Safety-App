import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'location_service.dart';
import 'firestore_service.dart';
import 'audio_service.dart';

class SosService {
  final LocationService _locationService = LocationService();
  final FirestoreService _firestoreService = FirestoreService();
  final AudioService _audioService = AudioService();

  Future<List<String>> _getEmergencyContacts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('contact_phones') ?? [];
  }

  Future<void> triggerSOS() async {
    // Start recording immediately
    await _audioService.startRecording();

    Position? position = await _locationService.getCurrentLocation();
    if (position == null) return;

    String mapsLink = _locationService.getMapsLink(position);
    String message =
        'EMERGENCY! I need help. My current location: $mapsLink';

    await _firestoreService.saveSosAlert(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    List<String> contacts = await _getEmergencyContacts();
    if (contacts.isNotEmpty) {
      final String smsUri =
          'sms:${contacts.join(',')}?body=${Uri.encodeComponent(message)}';
      await launchUrl(Uri.parse(smsUri));
    }
  }

  // Call this when user cancels SOS or after some time
  Future<String?> stopRecording() async {
    return await _audioService.stopRecording();
  }

  bool get isRecording => _audioService.isRecording;
}