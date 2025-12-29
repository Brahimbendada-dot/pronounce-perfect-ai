import 'dart:io';
import 'package:dio/dio.dart';
import '../models/analysis_result_model.dart';

class ApiService {
  late final Dio _dio;
  final String baseUrl;

  ApiService({this.baseUrl = 'http://localhost:8000'}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  // Health check endpoint
  Future<bool> health Check() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Analyze pronunciation
  Future<AnalysisResultModel> analyzePronunciation({
    required File audioFile,
    required String referenceText,
  }) async {
    try {
      // Create multipart form data
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          audioFile.path,
          filename: 'audio.wav',
        ),
        'reference_text': referenceText,
      });

      final response = await _dio.post(
        '/analyze-pronunciation',
        data: formData,
      );

      if (response.statusCode == 200) {
        return AnalysisResultModel.fromJson(response.data);
      } else {
        throw Exception('Failed to analyze pronunciation: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        // Return mock data if backend is unavailable
        return _getMockAnalysisResult();
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to analyze pronunciation: $e');
    }
  }

  // Mock analysis result for offline/testing mode
  AnalysisResultModel _getMockAnalysisResult() {
    return AnalysisResultModel(
      transcript: "This is a mock transcription for testing purposes.",
      score: 75,
      mispronuncedWords: ['pronunciation', 'testing'],
      phonemeErrors: [
        PhonemeError(
          word: 'pronunciation',
          expected: 'prə-ˌnən-sē-ˈā-shən',
          actual: 'prə-ˌnən-si-ˈā-shən',
          confidence: 0.85,
        ),
      ],
      feedback: 'Good overall pronunciation. Focus on vowel clarity and word stress patterns. Keep practicing!',
      accuracy: 0.78,
      fluency: 0.72,
      intonation: 0.75,
    );
  }
}
