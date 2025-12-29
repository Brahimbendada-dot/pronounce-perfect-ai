import 'dart:io';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../models/analysis_result_model.dart';
import '../../results/views/results_view.dart';

class AnalysisController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxBool isAnalyzing = true.obs;
  final RxString statusMessage = 'Analyzing your pronunciation...'.obs;
  
  Future<void> analyzeAudio({
    required File audioFile,
    required String referenceText,
  }) async {
    try {
      isAnalyzing.value = true;
      statusMessage.value = 'Processing audio...';
      
      await Future.delayed(const Duration(seconds: 1));
      statusMessage.value = 'Transcribing speech...';
      
      await Future.delayed(const Duration(seconds: 1));
      statusMessage.value = 'Analyzing pronunciation...';
      
      final result = await _apiService.analyzePronunciation(
        audioFile: audioFile,
        referenceText: referenceText,
      );
      
      // Navigate to results
      Get.off(() => ResultsView(result: result));
    } catch (e) {
      isAnalyzing.value = false;
      Get.snackbar('Error', 'Failed to analyze pronunciation: $e');
      Get.back();
    }
  }
}
