# Women-Safety-App

A Flutter mobile app that lets a user trigger a one-tap SOS alert in an emergency. It captures the user's GPS location, sends an SMS with a live map link to saved emergency contacts, starts audio recording, logs the alert to Firebase, and shows a K-Means–clustered "safety heatmap" of past SOS activity around Delhi.

## Features

- **One-tap SOS button** — grabs current GPS location, texts emergency contacts a Google Maps link, starts audio recording, and logs the alert to Firestore, all in one action.
- **Emergency contacts manager** — add/remove contacts (name + phone), stored locally with `shared_preferences`.
- **Automatic audio recording** — starts recording as soon as SOS is triggered (via `flutter_sound`) and can be stopped manually; useful as evidence.
- **Safety heatmap** — a Delhi-centered map (`flutter_map` + OpenStreetMap tiles) showing red/yellow/green risk zones, computed by a custom K-Means clustering service over a seeded dataset of Delhi localities plus live SOS reports from Firestore.
- **Simple registration flow** — first-run onboarding collects name/phone/email, stores the profile in Firestore, and remembers registration state locally so it isn't shown again.

## Tech Stack

- **Flutter / Dart**
- **Firebase** — Core, Cloud Firestore (SOS alerts + user registration)
- **Packages used:**
  - `provider` — app-wide state (location service)
  - `shared_preferences` — local storage for registration state and contacts
  - `geolocator` — device GPS access
  - `flutter_sound` — audio recording
  - `permission_handler` — runtime mic permission
  - `path_provider` — file system paths for recordings
  - `url_launcher` — launching the native SMS composer
  - `flutter_map` + `latlong2` — map rendering and geo types
  - `cloud_firestore` / `firebase_core`

## Project Structure

```
lib/
├── main.dart                     # App entry point, Firebase init, splash/router
├── firebase_options.dart         # FlutterFire-generated platform config
├── screens/
│   ├── registration_screen.dart  # First-run profile setup
│   ├── home_screen.dart          # SOS button, status chips, navigation
│   ├── contacts_screen.dart      # Emergency contacts CRUD
│   └── heatmap_screen.dart       # K-Means safety heatmap map view
└── services/
    ├── location_service.dart     # GPS permission + current position (ChangeNotifier)
    ├── audio_service.dart        # Start/stop SOS audio recording
    ├── firestore_service.dart    # Read/write SOS alerts in Firestore
    ├── sos_service.dart          # Orchestrates SOS: location + SMS + recording + logging
    └── kmeans_service.dart       # K-Means clustering + seeded Delhi risk-zone dataset
```

## How It Works

### SOS Flow (`sos_service.dart`)
1. Start audio recording immediately.
2. Fetch current GPS position (falls back to last known position if a fresh fix fails or times out).
3. Build a Google Maps link and emergency message.
4. Save the alert (lat/lng + server timestamp) to the `sos_alerts` Firestore collection.
5. Send an SMS with the message to all saved emergency contacts via the device's native SMS app.

### Safety Heatmap (`kmeans_service.dart` + `heatmap_screen.dart`)
- `KMeansService` runs a custom K-Means implementation over a large seeded dataset of Delhi localities (`delhiBasePoints`), combined with any live points passed in.
- Clusters are sorted by size and split into risk tiers by rank (top ~30% = high risk / red, next ~35% = moderate / yellow, remainder = safe / green).
- The result is rendered as colored `CircleMarker`s on an OpenStreetMap-tiled `FlutterMap` centered on Delhi.
- The screen also subscribes to live Firestore `sos_alerts` updates for future integration into the clustering.

### Registration & Persistence
- `RegistrationScreen` writes a new user document to the `users` Firestore collection and sets `is_registered = true` locally via `shared_preferences`, so the app skips onboarding on future launches (`main.dart`'s `SplashRouter`).
- Emergency contacts are stored as two parallel string lists (`contact_names`, `contact_phones`) in `shared_preferences`.

## Setup

### Prerequisites
- Flutter SDK installed
- A Firebase project with Cloud Firestore enabled
- FlutterFire CLI (`dart pub global activate flutterfire_cli`) if you need to regenerate `firebase_options.dart` for your own Firebase project

### Install & Run
```bash
flutter pub get
flutter run
```

### Required `pubspec.yaml` dependencies
Make sure the following are declared (versions per your Flutter SDK):
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core:
  cloud_firestore:
  provider:
  shared_preferences:
  geolocator:
  flutter_sound:
  permission_handler:
  path_provider:
  url_launcher:
  flutter_map:
  latlong2:
```

### Android/iOS permissions
Add the following to your platform configs:
- **Location** (fine/coarse) — for GPS
- **Microphone** — for audio recording
- **SMS** (Android, if not relying purely on the SMS intent) and internet access for Firestore/map tiles

## Security Note

⚠️ `firebase_options.dart` in this repo contains live Firebase API keys and project identifiers checked into source. Firebase web/mobile API keys aren't secret in the traditional sense (they identify the project rather than authorize access), but access should still be locked down with **Firestore Security Rules** so that, for example, `sos_alerts` and `users` can only be written by legitimate app instances/users, not read or written by anyone who finds the key. Before shipping, review and tighten your Firestore rules rather than leaving the default open/test-mode rules in place.

## Known Limitations / TODO

- `HeatmapScreen` currently runs K-Means on the seeded dataset only (`kMeans.run([])`); live Firestore SOS points are fetched but not yet fed into the clustering.
- No authentication — registration is local + a Firestore write, not tied to a Firebase Auth user.
- `print()` statements are used for debug logging throughout the services; consider replacing with a proper logger before release.
- No automated tests included.
