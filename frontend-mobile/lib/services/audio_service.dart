import 'dart:io';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class AudioService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  
  bool _isRecording = false;
  String? _currentRecordingPath;

  bool get isRecording => _isRecording;
  String? get currentRecordingPath => _currentRecordingPath;

  // Request microphone permission
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // Check if microphone permission is granted
  Future<bool> hasMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  // Start recording
  Future<void> startRecording() async {
    try {
      // Check permission
      if (!await hasMicrophonePermission()) {
        if (!await requestMicrophonePermission()) {
          throw Exception('Microphone permission denied');
        }
      }

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';

      // Check if recording is supported
      if (await _recorder.hasPermission()) {
        // Start recording in WAV format
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: 44100,
            bitRate: 128000,
            numChannels: 1,
          ),
          path: filePath,
        );

        _isRecording = true;
        _currentRecordingPath = filePath;
      } else {
        throw Exception('Recording permission not granted');
      }
    } catch (e) {
      throw Exception('Failed to start recording: $e');
    }
  }

  // Stop recording
  Future<String?> stopRecording() async {
    try {
      if (_isRecording) {
        final path = await _recorder.stop();
        _isRecording = false;
        _currentRecordingPath = path;
        return path;
      }
    } catch (e) {
      throw Exception('Failed to stop recording: $e');
    }
    return null;
  }

  // Cancel recording
  Future<void> cancelRecording() async {
    try {
      if (_isRecording) {
        await _recorder.stop();
        _isRecording = false;
        
        // Delete the recording file
        if (_currentRecordingPath != null) {
          final file = File(_currentRecordingPath!);
          if (await file.exists()) {
            await file.delete();
          }
        }
        _currentRecordingPath = null;
      }
    } catch (e) {
      throw Exception('Failed to cancel recording: $e');
    }
  }

  // Play audio from file path
  Future<void> playAudioFromFile(String filePath) async {
    try {
      await _player.setFilePath(filePath);
      await _player.play();
    } catch (e) {
      throw Exception('Failed to play audio: $e');
    }
  }

  // Play audio from URL
  Future<void> playAudioFromUrl(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      throw Exception('Failed to play audio from URL: $e');
    }
  }

  // Pause audio
  Future<void> pauseAudio() async {
    try {
      await _player.pause();
    } catch (e) {
      throw Exception('Failed to pause audio: $e');
    }
  }

  // Resume audio
  Future<void> resumeAudio() async {
    try {
      await _player.play();
    } catch (e) {
      throw Exception('Failed to resume audio: $e');
    }
  }

  // Stop audio
  Future<void> stopAudio() async {
    try {
      await _player.stop();
    } catch (e) {
      throw Exception('Failed to stop audio: $e');
    }
  }

  // Seek to position
  Future<void> seekTo(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      throw Exception('Failed to seek: $e');
    }
  }

  // Get audio duration
  Duration? get duration => _player.duration;

  // Get current position
  Duration? get position => _player.position;

  // Get player state stream
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  // Get position stream
  Stream<Duration> get positionStream => _player.positionStream;

  // Delete audio file
  Future<void> deleteAudioFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete audio file: $e');
    }
  }

  // Dispose resources
  Future<void> dispose() async {
    await _recorder.dispose();
    await _player.dispose();
  }
}
