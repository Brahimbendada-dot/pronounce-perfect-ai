import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/level_controller.dart';

class LevelSelectionView extends StatelessWidget {
  const LevelSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LevelController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Your Level'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              Text(
                'What\'s your English level?',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'We\'ll personalize your learning experience',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              Expanded(
                child: ListView(
                  children: [
                    _buildLevelCard(
                      context,
                      controller,
                      level: 'beginner',
                      title: 'Beginner',
                      description: 'Just starting with English pronunciation',
                      color: AppColors.beginner,
                      icon: Icons.trending_up,
                    ),
                    const SizedBox(height: 16),
                    _buildLevelCard(
                      context,
                      controller,
                      level: 'intermediate',
                      title: 'Intermediate',
                      description: 'Comfortable with basics, want to improve',
                      color: AppColors.intermediate,
                      icon: Icons.bar_chart,
                    ),
                    const SizedBox(height: 16),
                    _buildLevelCard(
                      context,
                      controller,
                      level: 'advanced',
                      title: 'Advanced',
                      description: 'Fluent, looking to perfect pronunciation',
                      color: AppColors.advanced,
                      icon: Icons.show_chart,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value || controller.selectedLevel.value.isEmpty
                    ? null
                    : controller.saveLevel,
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Continue'),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    LevelController controller, {
    required String level,
    required String title,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    return Obx(() {
      final isSelected = controller.selectedLevel.value == level;
      
      return GestureDetector(
        onTap: () => controller.selectLevel(level),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: isSelected ? color : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: color,
                  size: 28,
                ),
            ],
          ),
        ),
      );
    });
  }
}
