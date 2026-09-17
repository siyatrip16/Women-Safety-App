import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../services/kmeans_service.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<CircleMarker> _circles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHeatmapData();
  }

  void _loadHeatmapData() {
    print('>>> Starting heatmap load');

    // Load base data immediately without waiting for Firestore
    KMeansService kMeans = KMeansService(k: 20, maxIterations: 100);
    List<Cluster> clusters = kMeans.run([]); // empty live points for now

    print('>>> Clusters from base data: ${clusters.length}');

    List<CircleMarker> circles = clusters.map((cluster) {
      Color color;
      double radius;

      switch (cluster.riskLevel) {
        case 2:
          color = Colors.red.withValues(alpha: 0.6);
          radius = 2000;
          break;
        case 1:
          color = Colors.yellow.withValues(alpha: 0.6);
          radius = 1800;
          break;
        default:
          color = Colors.green.withValues(alpha: 0.6);
          radius = 1500;
      }

      return CircleMarker(
        point: cluster.center,
        radius: radius,
        useRadiusInMeter: true,
        color: color,
        borderStrokeWidth: 0,
      );
    }).toList();

    setState(() {
      _circles = circles;
      _loading = false;
    });

    // Also listen for live Firestore updates on top
    _firestoreService.getSosAlerts().listen((snapshot) {
      print('>>> Firestore docs: ${snapshot.docs.length}');
    }, onError: (e) {
      print('>>> Firestore error: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.map, color: Colors.red, size: 22),
            SizedBox(width: 8),
            Text(
              'Safety Heatmap',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.red, size: 14),
                SizedBox(width: 4),
                Text(
                  'AI Powered',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(28.6300, 77.2090),
              initialZoom: 11,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.women_safety_app',
              ),
              CircleLayer(circles: _circles),
            ],
          ),

          if (_loading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.red),
                    SizedBox(height: 12),
                    Text(
                      'Running K-Means clustering...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

          Positioned(
            bottom: 20,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'K-Means Clusters',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _legendItem(Colors.green, 'Safe zone'),
                  const SizedBox(height: 4),
                  _legendItem(Colors.yellow, 'Moderate risk'),
                  const SizedBox(height: 4),
                  _legendItem(Colors.red, 'High risk'),
                ],
              ),
            ),
          ),

          if (!_loading && _circles.isEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'No SOS data yet.\nTrigger SOS to generate heatmap.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}