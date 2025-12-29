import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../models/analysis_result_model.dart';
import '../../results/views/results_view.dart';

class AnalysisController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxBool isAnalyzing = true.obs;
  final RxString statusMessage = 'Analyzing your pronunciation...'.obs;

  Future<void> analyzeAudio({
    required String supabaseAudioPath,
    required String referenceText,
  }) async {
    try {
      isAnalyzing.value = true;
      statusMessage.value = 'Preparing audio...';

      await Future.delayed(const Duration(milliseconds: 500));
      statusMessage.value = 'Transcribing speech...';

      await Future.delayed(const Duration(milliseconds: 500));
      statusMessage.value = 'Analyzing pronunciation...';

      // Send Supabase path to backend for analysis
      final result = await _apiService.analyzePronunciation(
        supabaseAudioPath: supabaseAudioPath,
        referenceText: referenceText,
      );

      // Backend will delete the audio file from Supabase after processing

      // Navigate to results
      Get.off(() => ResultsView(result: result));
    } catch (e) {
      isAnalyzing.value = false;
      Get.snackbar('Error', 'Failed to analyze pronunciation: $e');
      Get.back();
    }
  }
}
