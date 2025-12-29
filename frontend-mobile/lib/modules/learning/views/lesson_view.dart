import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/lesson_model.dart';
import '../controllers/lesson_controller.dart';
import '../../recording/views/recording_view.dart';

class LessonView extends StatelessWidget {
  final LessonModel lesson;
  
  const LessonView({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LessonController());
    controller.setLesson(lesson);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Listen & Learn'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Lesson Title
              Text(
                lesson.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              
              const SizedBox(height: 24),
              
              // Audio Player Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Waveform Icon
                    Icon(
                      Icons.graphic_eq,
                      size: 80,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Play/Pause Button
                    Obx(() => FloatingActionButton.large(
                      onPressed: controller.isPlaying.value
                          ? controller.pauseAudio
                          : controller.playAudio,
                      backgroundColor: Colors.white,
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : Icon(
                              controller.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 48,
                              color: AppColors.primary,
                            ),
                    )),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'Listen to the reference audio',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Reference Text
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.text_fields, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Reference Text',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      lesson.referenceText,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Start Recording Button
              ElevatedButton.icon(
                onPressed: () => Get.to(() => RecordingView(lesson: lesson)),
                icon: const Icon(Icons.mic),
                label: const Text('Start Recording'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
