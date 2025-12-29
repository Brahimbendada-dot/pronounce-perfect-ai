import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/analysis_controller.dart';

class AnalysisView extends StatelessWidget {
  final String supabaseAudioPath;
  final String referenceText;

  const AnalysisView({
    super.key,
    required this.supabaseAudioPath,
    required this.referenceText,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnalysisController());

    // Start analysis immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.analyzeAudio(
        supabaseAudioPath: supabaseAudioPath,
        referenceText: referenceText,
      );
    });

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Analyzing Animation
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 2),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: 0.8 + (value * 0.2),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary.withOpacity(0.8),
                              AppColors.primaryLight.withOpacity(0.6),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.5 * value),
                              blurRadius: 40 * value,
                              spreadRadius: 10 * value,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.graphic_eq,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  onEnd: () {
                    // Loop animation
                  },
                ),

                const SizedBox(height: 40),

                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryLight,
                  ),
                  strokeWidth: 3,
                ),

                const SizedBox(height: 32),

                Obx(
                  () => Text(
                    controller.statusMessage.value,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'This may take a few moments',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
