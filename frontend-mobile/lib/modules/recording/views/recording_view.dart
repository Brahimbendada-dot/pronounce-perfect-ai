import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/lesson_model.dart';
import '../controllers/recording_controller.dart';

class RecordingView extends StatelessWidget {
  final LessonModel lesson;
  
  const RecordingView({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecordingController());
    controller.setLesson(lesson);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Record Your Voice'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Microphone Animation
              Expanded(
                child: Center(
                  child: Obx(() => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: controller.isRecording.value ? 200 : 160,
                    height: controller.isRecording.value ? 200 : 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: controller.isRecording.value
                            ? [Colors.red.shade400, Colors.red.shade600]
                            : [AppColors.primary, AppColors.primaryDark],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (controller.isRecording.value
                                  ? Colors.red
                                  : AppColors.primary)
                              .withOpacity(0.4),
                          blurRadius: controller.isRecording.value ? 32 : 16,
                          spreadRadius: controller.isRecording.value ? 8 : 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.mic,
                      size: 80,
                      color: Colors.white,
                    ),
                  )),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Recording Duration
              Obx(() => Text(
                _formatDuration(controller.recordingDuration.value),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
                textAlign: TextAlign.center,
              )),
              
              const SizedBox(height: 12),
              
              Obx(() => Text(
                controller.isRecording.value
                    ? 'Recording...'
                    : 'Tap to start recording',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              )),
              
              const SizedBox(height: 40),
              
              // Reference Text Reminder
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Read the text clearly and naturally',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Control Buttons
              Obx(() => controller.isRecording.value
                  ? Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.cancelRecording,
                            icon: const Icon(Icons.close),
                            label: const Text('Cancel'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.stopRecording,
                            icon: const Icon(Icons.stop),
                            label: const Text('Stop'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton.icon(
                      onPressed: controller.startRecording,
                      icon: const Icon(Icons.mic),
                      label: const Text('Start Recording'),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
