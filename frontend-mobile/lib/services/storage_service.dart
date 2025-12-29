import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class AudioStorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String bucketName = 'audio-recordings';

  /// Upload audio file to Supabase Storage
  /// Returns the file path in Supabase
  Future<String> uploadAudio({
    required File audioFile,
    required String userId,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${userId}_$timestamp.wav';
      final filePath = '$userId/$fileName';

      // Upload to Supabase Storage
      await _supabase.storage
          .from(bucketName)
          .upload(
            filePath,
            audioFile,
            fileOptions: const FileOptions(
              contentType: 'audio/wav',
              upsert: false,
            ),
          );

      return filePath;
    } catch (e) {
      throw Exception('Failed to upload audio: $e');
    }
  }

  /// Get public URL for audio file (for backend to download)
  /// Note: Bucket is private, so this creates a signed URL
  Future<String> getSignedUrl(String filePath) async {
    try {
      final signedUrl = await _supabase.storage
          .from(bucketName)
          .createSignedUrl(filePath, 3600); // 1 hour expiry

      return signedUrl;
    } catch (e) {
      throw Exception('Failed to get signed URL: $e');
    }
  }

  /// Delete audio file from Supabase Storage
  /// Called by backend after processing
  Future<void> deleteAudio(String filePath) async {
    try {
      await _supabase.storage.from(bucketName).remove([filePath]);
    } catch (e) {
      throw Exception('Failed to delete audio: $e');
    }
  }

  /// Check if bucket exists and create if needed
  Future<void> ensureBucketExists() async {
    try {
      // Try to get bucket info
      await _supabase.storage.getBucket(bucketName);
    } catch (e) {
      // Bucket doesn't exist, but we can't create it from client
      // This should be done manually in Supabase dashboard or via service role
      throw Exception(
        'Bucket "$bucketName" does not exist. Please create it in Supabase dashboard with private access.',
      );
    }
  }
}
