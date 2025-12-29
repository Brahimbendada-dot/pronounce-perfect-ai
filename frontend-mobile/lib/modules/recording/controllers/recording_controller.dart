import 'dart:io';
import 'package:get/get.dart';
import '../../../services/audio_service.dart';
import '../../../models/lesson_model.dart';
import '../../analysis/views/analysis_view.dart';

class RecordingController extends GetxController {
  final AudioService _audioService = AudioService();
  final Rx<LessonModel?> currentLesson = Rx<LessonModel?>(null);
  final RxBool isRecording = false.obs;
  final RxBool hasPermission = false.obs;
  final RxInt recordingDuration = 0.obs;
  String? _recordingPath;

  void setLesson(LessonModel lesson) {
    currentLesson.value = lesson;
  }

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  Future<void> checkPermission() async {
    hasPermission.value = await _audioService.hasMicrophonePermission();
  }

  Future<void> requestPermission() async {
    hasPermission.value = await _audioService.requestMicrophonePermission();
    if (!hasPermission.value) {
      Get.snackbar('Permission Denied', 'Microphone permission is required to record audio');
    }
  }

  Future<void> startRecording() async {
    try {
      if (!hasPermission.value) {
        await requestPermission();
        if (!hasPermission.value) return;
      }

      await _audioService.startRecording();
      isRecording.value = true;
      
      // Start timer
      _startTimer();
    } catch (e) {
      Get.snackbar('Error', 'Failed to start recording: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _audioService.stopRecording();
      isRecording.value = false;
      recordingDuration.value = 0;
      
      if (path != null && currentLesson.value != null) {
        _recordingPath = path;
        // Navigate to analysis
        Get.to(() => AnalysisView(
          audioFile: File(path),
          referenceText: currentLesson.value!.referenceText,
        ));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop recording: $e');
    }
  }

  Future<void> cancelRecording() async {
    try {
      await _audioService.cancelRecording();
      isRecording.value = false;
      recordingDuration.value = 0;
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel recording: $e');
    }
  }

  void _startTimer() {
    recordingDuration.value = 0;
    Future.doWhile(() async {
      if (!isRecording.value) return false;
      await Future.delayed(const Duration(seconds: 1));
      if (isRecording.value) {
        recordingDuration.value++;
        return true;
      }
      return false;
    });
  }

  @override
  void onClose() {
    if (isRecording.value) {
      _audioService.cancelRecording();
    }
    super.onClose();
  }
}
