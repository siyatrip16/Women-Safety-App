import 'package:latlong2/latlong.dart';

class Cluster {
  LatLng center;
  List<LatLng> points;
  int riskLevel;

  Cluster({
    required this.center,
    required this.points,
    required this.riskLevel,
  });
}

class KMeansService {
  final int k;
  final int maxIterations;

  KMeansService({this.k = 8, this.maxIterations = 100});

  static List<LatLng> get delhiBasePoints => [
    // HIGH RISK - Paharganj
    LatLng(28.6448, 77.2167), LatLng(28.6449, 77.2170),
    LatLng(28.6450, 77.2165), LatLng(28.6447, 77.2169),
    LatLng(28.6451, 77.2168), LatLng(28.6446, 77.2171),
    LatLng(28.6452, 77.2166), LatLng(28.6445, 77.2172),
    LatLng(28.6453, 77.2164), LatLng(28.6444, 77.2173),

    // HIGH RISK - Seelampur
    LatLng(28.6637, 77.2273), LatLng(28.6638, 77.2275),
    LatLng(28.6636, 77.2271), LatLng(28.6639, 77.2274),
    LatLng(28.6640, 77.2276), LatLng(28.6635, 77.2272),
    LatLng(28.6641, 77.2277), LatLng(28.6634, 77.2270),
    LatLng(28.6642, 77.2278), LatLng(28.6633, 77.2269),

    // HIGH RISK - Shahdara
    LatLng(28.6517, 77.2219), LatLng(28.6518, 77.2220),
    LatLng(28.6516, 77.2218), LatLng(28.6519, 77.2221),
    LatLng(28.6515, 77.2217), LatLng(28.6520, 77.2222),
    LatLng(28.6521, 77.2223), LatLng(28.6514, 77.2216),
    LatLng(28.6522, 77.2224), LatLng(28.6513, 77.2215),

    // HIGH RISK - Uttam Nagar
    LatLng(28.6562, 77.0927), LatLng(28.6563, 77.0928),
    LatLng(28.6561, 77.0926), LatLng(28.6564, 77.0929),
    LatLng(28.6560, 77.0925), LatLng(28.6565, 77.0930),
    LatLng(28.6559, 77.0924), LatLng(28.6566, 77.0931),
    LatLng(28.6558, 77.0923), LatLng(28.6567, 77.0932),

    // HIGH RISK - Mangolpuri
    LatLng(28.7057, 77.0748), LatLng(28.7058, 77.0749),
    LatLng(28.7056, 77.0747), LatLng(28.7059, 77.0750),
    LatLng(28.7055, 77.0746), LatLng(28.7060, 77.0751),
    LatLng(28.7054, 77.0745), LatLng(28.7061, 77.0752),

    // HIGH RISK - Mustafabad
    LatLng(28.6925, 77.2891), LatLng(28.6926, 77.2892),
    LatLng(28.6924, 77.2890), LatLng(28.6927, 77.2893),
    LatLng(28.6923, 77.2889), LatLng(28.6928, 77.2894),
    LatLng(28.6922, 77.2888), LatLng(28.6929, 77.2895),

    // HIGH RISK - Trilokpuri
    LatLng(28.6197, 77.3108), LatLng(28.6198, 77.3109),
    LatLng(28.6196, 77.3107), LatLng(28.6199, 77.3110),
    LatLng(28.6195, 77.3106), LatLng(28.6200, 77.3111),
    LatLng(28.6194, 77.3105), LatLng(28.6201, 77.3112),

    // HIGH RISK - Nand Nagri
    LatLng(28.6850, 77.2991), LatLng(28.6851, 77.2992),
    LatLng(28.6849, 77.2990), LatLng(28.6852, 77.2993),
    LatLng(28.6848, 77.2989), LatLng(28.6853, 77.2994),

    // MODERATE RISK - Karol Bagh
    LatLng(28.6514, 77.1907), LatLng(28.6516, 77.1909),
    LatLng(28.6513, 77.1905), LatLng(28.6517, 77.1910),
    LatLng(28.6512, 77.1904), LatLng(28.6518, 77.1911),

    // MODERATE RISK - Rohini
    LatLng(28.6739, 77.1671), LatLng(28.6740, 77.1672),
    LatLng(28.6738, 77.1670), LatLng(28.6741, 77.1673),
    LatLng(28.6737, 77.1669), LatLng(28.6742, 77.1674),

    // MODERATE RISK - Badarpur
    LatLng(28.5355, 77.2511), LatLng(28.5356, 77.2512),
    LatLng(28.5354, 77.2510), LatLng(28.5357, 77.2513),
    LatLng(28.5353, 77.2509), LatLng(28.5358, 77.2514),

    // MODERATE RISK - Lajpat Nagar
    LatLng(28.6129, 77.2295), LatLng(28.6130, 77.2296),
    LatLng(28.6128, 77.2294), LatLng(28.6131, 77.2297),
    LatLng(28.6127, 77.2293), LatLng(28.6132, 77.2298),

    // MODERATE RISK - Sangam Vihar
    LatLng(28.5089, 77.2500), LatLng(28.5090, 77.2501),
    LatLng(28.5088, 77.2499), LatLng(28.5091, 77.2502),
    LatLng(28.5087, 77.2498), LatLng(28.5092, 77.2503),

    // MODERATE RISK - Dwarka
    LatLng(28.5921, 77.0460), LatLng(28.5922, 77.0461),
    LatLng(28.5920, 77.0459), LatLng(28.5923, 77.0462),
    LatLng(28.5919, 77.0458), LatLng(28.5924, 77.0463),

    // MODERATE RISK - Vikaspuri
    LatLng(28.6389, 77.0731), LatLng(28.6390, 77.0732),
    LatLng(28.6388, 77.0730), LatLng(28.6391, 77.0733),
    LatLng(28.6387, 77.0729),

    // MODERATE RISK - Burari
    LatLng(28.7386, 77.2050), LatLng(28.7387, 77.2051),
    LatLng(28.7385, 77.2049), LatLng(28.7388, 77.2052),
    LatLng(28.7384, 77.2048),

    // SAFE - Connaught Place
    LatLng(28.6315, 77.2167), LatLng(28.6316, 77.2168),
    LatLng(28.6314, 77.2166),

    // SAFE - Vasant Kunj
    LatLng(28.5918, 77.1671), LatLng(28.5919, 77.1672),
    LatLng(28.5917, 77.1670),

    // SAFE - Saket
    LatLng(28.5244, 77.1855), LatLng(28.5245, 77.1856),
    LatLng(28.5243, 77.1854),

    // SAFE - Mayur Vihar
    LatLng(28.6279, 77.3649), LatLng(28.6280, 77.3650),
    LatLng(28.6278, 77.3648),

    // SAFE - Hauz Khas
    LatLng(28.5494, 77.2001), LatLng(28.5495, 77.2002),
    LatLng(28.5493, 77.2000),

    // SAFE - Lodhi Colony
    LatLng(28.5931, 77.2274), LatLng(28.5932, 77.2275),
    LatLng(28.5930, 77.2273),

    // SAFE - Greater Kailash
    LatLng(28.5477, 77.2436), LatLng(28.5478, 77.2437),
    LatLng(28.5476, 77.2435),

    // SAFE - Janakpuri
    LatLng(28.6219, 77.0878), LatLng(28.6220, 77.0879),
    LatLng(28.6218, 77.0877),

    // SAFE - Pitampura
    LatLng(28.7006, 77.1311), LatLng(28.7007, 77.1312),
    LatLng(28.7005, 77.1310),

    // SAFE - Defence Colony
    LatLng(28.5721, 77.2314), LatLng(28.5722, 77.2315),
    LatLng(28.5720, 77.2313),
    // HIGH RISK - Seemapuri
    LatLng(28.6782, 77.3142), LatLng(28.6783, 77.3143),
    LatLng(28.6781, 77.3141), LatLng(28.6784, 77.3144),
    LatLng(28.6780, 77.3140), LatLng(28.6785, 77.3145),
    LatLng(28.6779, 77.3139), LatLng(28.6786, 77.3146),

    // HIGH RISK - Bhajanpura
    LatLng(28.6958, 77.2700), LatLng(28.6959, 77.2701),
    LatLng(28.6957, 77.2699), LatLng(28.6960, 77.2702),
    LatLng(28.6956, 77.2698), LatLng(28.6961, 77.2703),
    LatLng(28.6955, 77.2697), LatLng(28.6962, 77.2704),

    // HIGH RISK - Gokulpuri
    LatLng(28.6862, 77.2800), LatLng(28.6863, 77.2801),
    LatLng(28.6861, 77.2799), LatLng(28.6864, 77.2802),
    LatLng(28.6860, 77.2798), LatLng(28.6865, 77.2803),

    // HIGH RISK - Kirari
    LatLng(28.7250, 77.0650), LatLng(28.7251, 77.0651),
    LatLng(28.7249, 77.0649), LatLng(28.7252, 77.0652),
    LatLng(28.7248, 77.0648), LatLng(28.7253, 77.0653),

    // HIGH RISK - Narela
    LatLng(28.8528, 77.0938), LatLng(28.8529, 77.0939),
    LatLng(28.8527, 77.0937), LatLng(28.8530, 77.0940),
    LatLng(28.8526, 77.0936), LatLng(28.8531, 77.0941),

    // MODERATE - Wazirpur
    LatLng(28.6980, 77.1670), LatLng(28.6981, 77.1671),
    LatLng(28.6979, 77.1669), LatLng(28.6982, 77.1672),
    LatLng(28.6978, 77.1668),

    // MODERATE - Shakarpur
    LatLng(28.6350, 77.2850), LatLng(28.6351, 77.2851),
    LatLng(28.6349, 77.2849), LatLng(28.6352, 77.2852),
    LatLng(28.6348, 77.2848),

    // MODERATE - Malviya Nagar
    LatLng(28.5274, 77.2099), LatLng(28.5275, 77.2100),
    LatLng(28.5273, 77.2098), LatLng(28.5276, 77.2101),
    LatLng(28.5272, 77.2097),

    // MODERATE - Tilak Nagar
    LatLng(28.6411, 77.0983), LatLng(28.6412, 77.0984),
    LatLng(28.6410, 77.0982), LatLng(28.6413, 77.0985),
    LatLng(28.6409, 77.0981),

    // MODERATE - Sultanpuri
    LatLng(28.7100, 77.0750), LatLng(28.7101, 77.0751),
    LatLng(28.7099, 77.0749), LatLng(28.7102, 77.0752),
    LatLng(28.7098, 77.0748),

    // SAFE - Vasant Vihar
    LatLng(28.5673, 77.1569), LatLng(28.5674, 77.1570),
    LatLng(28.5672, 77.1568),

    // SAFE - Rajouri Garden
    LatLng(28.6477, 77.1187), LatLng(28.6478, 77.1188),
    LatLng(28.6476, 77.1186),

    // SAFE - Lodi Road
    LatLng(28.5918, 77.2281), LatLng(28.5919, 77.2282),
    LatLng(28.5917, 77.2280),

    // SAFE - Nehru Place
    LatLng(28.5491, 77.2515), LatLng(28.5492, 77.2516),
    LatLng(28.5490, 77.2514),

    // SAFE - Model Town
    LatLng(28.7144, 77.1916), LatLng(28.7145, 77.1917),
    LatLng(28.7143, 77.1915),

    // SAFE - Patel Nagar
    LatLng(28.6527, 77.1590), LatLng(28.6528, 77.1591),
    LatLng(28.6526, 77.1589),
    // HIGH RISK - Jahangirpuri
    LatLng(28.7280, 77.1640), LatLng(28.7281, 77.1641),
    LatLng(28.7279, 77.1639), LatLng(28.7282, 77.1642),
    LatLng(28.7278, 77.1638), LatLng(28.7283, 77.1643),
    LatLng(28.7277, 77.1637), LatLng(28.7284, 77.1644),

    // HIGH RISK - Maujpur
    LatLng(28.6900, 77.2750), LatLng(28.6901, 77.2751),
    LatLng(28.6899, 77.2749), LatLng(28.6902, 77.2752),
    LatLng(28.6898, 77.2748), LatLng(28.6903, 77.2753),
    LatLng(28.6897, 77.2747), LatLng(28.6904, 77.2754),

    // HIGH RISK - Kalyanpuri
    LatLng(28.6050, 77.3100), LatLng(28.6051, 77.3101),
    LatLng(28.6049, 77.3099), LatLng(28.6052, 77.3102),
    LatLng(28.6048, 77.3098), LatLng(28.6053, 77.3103),
    LatLng(28.6047, 77.3097), LatLng(28.6054, 77.3104),

    // HIGH RISK - Palam
    LatLng(28.5921, 77.0747), LatLng(28.5922, 77.0748),
    LatLng(28.5920, 77.0746), LatLng(28.5923, 77.0749),
    LatLng(28.5919, 77.0745), LatLng(28.5924, 77.0750),
    LatLng(28.5918, 77.0744), LatLng(28.5925, 77.0751),

    // HIGH RISK - Bindapur
    LatLng(28.6180, 77.0650), LatLng(28.6181, 77.0651),
    LatLng(28.6179, 77.0649), LatLng(28.6182, 77.0652),
    LatLng(28.6178, 77.0648), LatLng(28.6183, 77.0653),
    LatLng(28.6177, 77.0647), LatLng(28.6184, 77.0654),

    // HIGH RISK - Shastri Park
    LatLng(28.6680, 77.2580), LatLng(28.6681, 77.2581),
    LatLng(28.6679, 77.2579), LatLng(28.6682, 77.2582),
    LatLng(28.6678, 77.2578), LatLng(28.6683, 77.2583),
    LatLng(28.6677, 77.2577), LatLng(28.6684, 77.2584),

    // HIGH RISK - Welcome Colony
    LatLng(28.6820, 77.2680), LatLng(28.6821, 77.2681),
    LatLng(28.6819, 77.2679), LatLng(28.6822, 77.2682),
    LatLng(28.6818, 77.2678), LatLng(28.6823, 77.2683),

    // HIGH RISK - Khajuri Khas
    LatLng(28.7050, 77.2780), LatLng(28.7051, 77.2781),
    LatLng(28.7049, 77.2779), LatLng(28.7052, 77.2782),
    LatLng(28.7048, 77.2778), LatLng(28.7053, 77.2783),

    // MODERATE - Patparganj
    LatLng(28.6250, 77.3000), LatLng(28.6251, 77.3001),
    LatLng(28.6249, 77.2999), LatLng(28.6252, 77.3002),
    LatLng(28.6248, 77.2998),

    // MODERATE - Yamuna Vihar
    LatLng(28.6950, 77.2650), LatLng(28.6951, 77.2651),
    LatLng(28.6949, 77.2649), LatLng(28.6952, 77.2652),
    LatLng(28.6948, 77.2648),

    // MODERATE - Ashok Vihar
    LatLng(28.6950, 77.1750), LatLng(28.6951, 77.1751),
    LatLng(28.6949, 77.1749), LatLng(28.6952, 77.1752),
    LatLng(28.6948, 77.1748),

    // MODERATE - Najafgarh
    LatLng(28.6092, 76.9797), LatLng(28.6093, 76.9798),
    LatLng(28.6091, 76.9796), LatLng(28.6094, 76.9799),
    LatLng(28.6090, 76.9795),

    // MODERATE - Shahdara Extension
    LatLng(28.6600, 77.2900), LatLng(28.6601, 77.2901),
    LatLng(28.6599, 77.2899), LatLng(28.6602, 77.2902),
    LatLng(28.6598, 77.2898),

    // MODERATE - Dabri
    LatLng(28.6050, 77.0780), LatLng(28.6051, 77.0781),
    LatLng(28.6049, 77.0779), LatLng(28.6052, 77.0782),
    LatLng(28.6048, 77.0778),

    // MODERATE - Nangloi
    LatLng(28.6680, 77.0580), LatLng(28.6681, 77.0581),
    LatLng(28.6679, 77.0579), LatLng(28.6682, 77.0582),
    LatLng(28.6678, 77.0578),

    // MODERATE - Govindpuri
    LatLng(28.5280, 77.2580), LatLng(28.5281, 77.2581),
    LatLng(28.5279, 77.2579), LatLng(28.5282, 77.2582),
    LatLng(28.5278, 77.2578),

    // SAFE - Civil Lines
    LatLng(28.6800, 77.2250), LatLng(28.6801, 77.2251),
    LatLng(28.6799, 77.2249),

    // SAFE - Chanakyapuri
    LatLng(28.5921, 77.1671), LatLng(28.5922, 77.1672),
    LatLng(28.5920, 77.1670),

    // SAFE - Diplomatic Enclave
    LatLng(28.5980, 77.1850), LatLng(28.5981, 77.1851),
    LatLng(28.5979, 77.1849),

    // SAFE - Nizamuddin
    LatLng(28.5880, 77.2480), LatLng(28.5881, 77.2481),
    LatLng(28.5879, 77.2479),

    // SAFE - Kalkaji
    LatLng(28.5350, 77.2550), LatLng(28.5351, 77.2551),
    LatLng(28.5349, 77.2549),

    // SAFE - Munirka
    LatLng(28.5530, 77.1750), LatLng(28.5531, 77.1751),
    LatLng(28.5529, 77.1749),

    // SAFE - RK Puram
    LatLng(28.5650, 77.1780), LatLng(28.5651, 77.1781),
    LatLng(28.5649, 77.1779),

    // SAFE - Safdarjung
    LatLng(28.5680, 77.2050), LatLng(28.5681, 77.2051),
    LatLng(28.5679, 77.2049),

    // SAFE - Andrews Ganj
    LatLng(28.5750, 77.2280), LatLng(28.5751, 77.2281),
    LatLng(28.5749, 77.2279),

    // SAFE - Siri Fort
    LatLng(28.5480, 77.2180), LatLng(28.5481, 77.2181),
    LatLng(28.5479, 77.2179),

    // SAFE - Panchsheel
    LatLng(28.5380, 77.2080), LatLng(28.5381, 77.2081),
    LatLng(28.5379, 77.2079),
  ];

  double _distance(LatLng a, LatLng b) {
    double dlat = a.latitude - b.latitude;
    double dlng = a.longitude - b.longitude;
    return (dlat * dlat + dlng * dlng);
  }

  LatLng _mean(List<LatLng> points) {
    double lat = 0, lng = 0;
    for (var p in points) {
      lat += p.latitude;
      lng += p.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }

  List<Cluster> run(List<LatLng> livePoints) {
    List<LatLng> allPoints = [...delhiBasePoints, ...livePoints];
    if (allPoints.isEmpty) return [];

    int clusterCount = allPoints.length < k ? allPoints.length : k;
    List<LatLng> centroids = List.from(allPoints.take(clusterCount));
    List<int> assignments = List.filled(allPoints.length, 0);

    for (int iter = 0; iter < maxIterations; iter++) {
      bool changed = false;
      for (int i = 0; i < allPoints.length; i++) {
        int nearest = 0;
        double minDist = double.infinity;
        for (int j = 0; j < centroids.length; j++) {
          double d = _distance(allPoints[i], centroids[j]);
          if (d < minDist) {
            minDist = d;
            nearest = j;
          }
        }
        if (assignments[i] != nearest) {
          assignments[i] = nearest;
          changed = true;
        }
      }
      if (!changed) break;
      for (int j = 0; j < clusterCount; j++) {
        List<LatLng> clusterPoints = [];
        for (int i = 0; i < allPoints.length; i++) {
          if (assignments[i] == j) clusterPoints.add(allPoints[i]);
        }
        if (clusterPoints.isNotEmpty) {
          centroids[j] = _mean(clusterPoints);
        }
      }
    }

    List<List<LatLng>> clusterPoints =
    List.generate(clusterCount, (_) => []);
    for (int i = 0; i < allPoints.length; i++) {
      clusterPoints[assignments[i]].add(allPoints[i]);
    }

    List<Cluster> clusters = [];
    for (int j = 0; j < clusterCount; j++) {
      if (clusterPoints[j].isEmpty) continue;
      clusters.add(Cluster(
        center: centroids[j],
        points: clusterPoints[j],
        riskLevel: 0,
      ));
    }

    clusters.sort((a, b) => b.points.length.compareTo(a.points.length));

    int total = clusters.length;
    for (int i = 0; i < total; i++) {
      double ratio = i / total;
      if (ratio < 0.3) {
        clusters[i].riskLevel = 2;
      } else if (ratio < 0.65) {
        clusters[i].riskLevel = 1;
      } else {
        clusters[i].riskLevel = 0;
      }
    }

    return clusters;
  }
}