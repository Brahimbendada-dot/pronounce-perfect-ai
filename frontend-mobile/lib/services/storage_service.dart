import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload profile image
  Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId.jpg');
      
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Delete profile image
  Future<void> deleteProfileImage(String userId) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId.jpg');
      await ref.delete();
    } catch (e) {
      // Ignore error if file doesn't exist
      if (!e.toString().contains('object-not-found')) {
        throw Exception('Failed to delete profile image: $e');
      }
    }
  }

  // Get download URL for profile image
  Future<String?> getProfileImageUrl(String userId) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId.jpg');
      return await ref.getDownloadURL();
    } catch (e) {
      // Return null if image doesn't exist
      return null;
    }
  }
}
