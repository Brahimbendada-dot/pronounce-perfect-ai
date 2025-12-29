import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/lesson_model.dart';
import '../../learning/views/lesson_view.dart';
import '../../profile/views/profile_view.dart';

class SubjectsView extends StatelessWidget {
  const SubjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Choose Your Topic'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.to(() => const ProfileView()),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'What do you want to learn today?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              
              const SizedBox(height: 24),
              
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildSubjectCard(
                      context,
                      title: 'Daily\nConversation',
                      icon: Icons.chat_bubble_outline,
                      color: AppColors.dailyConversation,
                      onTap: () => _goToLesson('daily'),
                    ),
                    _buildSubjectCard(
                      context,
                      title: 'Business\nEnglish',
                      icon: Icons.business_center_outlined,
                      color: AppColors.businessEnglish,
                      onTap: () => _goToLesson('business'),
                    ),
                    _buildSubjectCard(
                      context,
                      title: 'Academic\nEnglish',
                      icon: Icons.school_outlined,
                      color: AppColors.academicEnglish,
                      onTap: () => _goToLesson('academic'),
                    ),
                    _buildSubjectCard(
                      context,
                      title: 'Travel\nEnglish',
                      icon: Icons.flight_outlined,
                      color: AppColors.travelEnglish,
                      onTap: () => _goToLesson('travel'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToLesson(String subjectId) {
    // Mock lesson data - in real app would fetch from Firestore
    final lesson = LessonModel(
      id: '1',
      subjectId: subjectId,
      title: 'Introduction to ${subjectId.capitalize} English',
      referenceText: 'Hello, how are you today? I hope you are doing well. Let\'s practice your English pronunciation together.',
      audioUrl: 'https://example.com/audio.mp3',
      duration: 5,
      difficulty: 'beginner',
    );
    
    Get.to(() => LessonView(lesson: lesson));
  }
}
