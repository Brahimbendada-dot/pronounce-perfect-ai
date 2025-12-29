import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../subjects/views/subjects_view.dart';

class LevelController extends GetxController {
  final AuthService _authService = AuthService();
  final RxString selectedLevel = ''.obs;
  final RxBool isLoading = false.obs;

  void selectLevel(String level) {
    selectedLevel.value = level;
  }

  Future<void> saveLevel() async {
    if (selectedLevel.value.isEmpty) {
      Get.snackbar('Error', 'Please select a level');
      return;
    }

    try {
      isLoading.value = true;
      
      final userId = _authService.currentUser?.uid;
      if (userId != null) {
        await _authService.updateUserData(userId, {
          'level': selectedLevel.value,
        });
        
        Get.offAll(() => const SubjectsView());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save level');
    } finally {
      isLoading.value = false;
    }
  }
}
