import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../models/user_model.dart';
import '../../subjects/views/subjects_view.dart';
import '../views/welcome_view.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Observable variables
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Obscure password
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Monitor auth state changes
    _authService.authStateChanges.listen((user) async {
      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        currentUser.value = userData;
      } else {
        currentUser.value = null;
      }
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // Sign in with email and password
  Future<void> signInWithEmail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        errorMessage.value = 'Please fill in all fields';
        return;
      }

      final user = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (user != null) {
        currentUser.value = user;
        Get.offAll(() => const SubjectsView());
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final email = emailController.text.trim();
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;
      final displayName = displayNameController.text.trim();

      if (email.isEmpty || password.isEmpty || displayName.isEmpty) {
        errorMessage.value = 'Please fill in all fields';
        return;
      }

      if (password != confirmPassword) {
        errorMessage.value = 'Passwords do not match';
        return;
      }

      if (password.length < 6) {
        errorMessage.value = 'Password must be at least 6 characters';
        return;
      }

      final user = await _authService.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (user != null) {
        currentUser.value = user;
        Get.offAll(() => const WelcomeView());
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authService.signInWithGoogle();

      if (user != null) {
        currentUser.value = user;
        
        // Check if user hasselected level
        if (user.level == 'beginner' && user.lessonsCompleted == 0) {
          // New user, go to welcome
          Get.offAll(() => const WelcomeView());
        } else {
          // Existing user, go to subjects
          Get.offAll(() => const SubjectsView());
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (email.isEmpty) {
        errorMessage.value = 'Please enter your email';
        return;
      }

      await _authService.sendPasswordResetEmail(email);

      Get.snackbar(
        'Success',
        'Password reset email sent. Please check your inbox.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back();
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      currentUser.value = null;
      Get.offAll(() => const LoginView());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
