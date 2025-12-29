import 'package:get/get.dart';
import '../../../services/audio_service.dart';
import '../../../models/lesson_model.dart';

class LessonController extends GetxController {
  final AudioService _audioService = AudioService();
  final Rx<LessonModel?> currentLesson = Rx<LessonModel?>(null);
  final RxBool isPlaying = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<Duration> currentPosition = const Duration().obs;
  final Rx<Duration> totalDuration = const Duration().obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to player state
    _audioService.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
    
    // Listen to position changes
    _audioService.positionStream.listen((position) {
      currentPosition.value = position;
    });
  }

  void setLesson(LessonModel lesson) {
    currentLesson.value = lesson;
  }

  Future<void> playAudio() async {
    try {
      if (currentLesson.value?.audioUrl != null) {
        isLoading.value = true;
        // In real app, this would play from URL
        // For now, we'll just toggle the playing state
        await Future.delayed(const Duration(milliseconds: 500));
        isPlaying.value = true;
        totalDuration.value = const Duration(minutes: 3); // Mock duration
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to play audio');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pauseAudio() async {
    try {
      await _audioService.pauseAudio();
    } catch (e) {
      Get.snackbar('Error', 'Failed to pause audio');
    }
  }

  Future<void> stopAudio() async {
    try {
      await _audioService.stopAudio();
      isPlaying.value = false;
      currentPosition.value = const Duration();
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop audio');
    }
  }

  @override
  void onClose() {
    _audioService.dispose();
    super.onClose();
  }
}
