import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  bool _isInitialized = false;
  String? _currentFilePath;

  bool get isRecording => _isRecording;
  String? get currentFilePath => _currentFilePath;

  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    await _recorder.openRecorder();
    _isInitialized = true;
  }

  Future<void> startRecording() async {
    try {
      bool hasPermission = await requestPermission();
      if (!hasPermission) {
        print('>>> Microphone permission denied');
        return;
      }

      await _initialize();

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final dir = await getExternalStorageDirectory();
      _currentFilePath = '${dir!.path}/sos_recording_$timestamp.aac';


      await _recorder.startRecorder(
        toFile: _currentFilePath,
        codec: Codec.aacADTS,
      );

      _isRecording = true;
      print('>>> Recording started: $_currentFilePath');
    } catch (e) {
      print('>>> Recording error: $e');
    }
  }

  Future<String?> stopRecording() async {
    try {
      if (!_isRecording) return null;
      final path = await _recorder.stopRecorder();
      _isRecording = false;
      print('>>> Recording stopped: $path');
      return path;
    } catch (e) {
      print('>>> Stop recording error: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
  }
}