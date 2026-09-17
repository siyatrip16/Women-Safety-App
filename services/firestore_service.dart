import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveSosAlert({
    required double latitude,
    required double longitude,
  }) async {
    await _db.collection('sos_alerts').add({
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getSosAlerts() {
    return _db.collection('sos_alerts').snapshots();
  }
}