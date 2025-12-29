import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/analysis_result_model.dart';
import '../../subjects/views/subjects_view.dart';

class ResultsView extends StatelessWidget {
  final AnalysisResultModel result;
  
  const ResultsView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Results'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.offAll(() => const SubjectsView()),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Score Circle
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: CircularProgressIndicator(
                        value: result.score / 100,
                        strokeWidth: 12,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getScoreColor(result.score),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${result.score}',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(result.score),
                          ),
                        ),
                        Text(
                          'Score',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Metrics
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      label: 'Accuracy',
                      value: '${(result.accuracy * 100).toInt()}%',
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      label: 'Fluency',
                      value: '${(result.fluency * 100).toInt()}%',
                      color: AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      label: 'Intonation',
                      value: '${(result.intonation * 100).toInt()}%',
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Transcript
              _buildSection(
                context,
                title: 'Your Speech',
                icon: Icons.text_fields,
                child: Text(
                  result.transcript,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Mispronounced Words
              if (result.mispronuncedWords.isNotEmpty)
                _buildSection(
                  context,
                  title: 'Words to Practice',
                  icon: Icons.warning_amber_outlined,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: result.mispronuncedWords.map((word) {
                      return Chip(
                        label: Text(word),
                        backgroundColor: AppColors.warning.withOpacity(0.1),
                        side: BorderSide(color: AppColors.warning.withOpacity(0.3)),
                        labelStyle: TextStyle(color: AppColors.warning),
                      );
                    }).toList(),
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // Feedback
              _buildSection(
                context,
                title: 'Feedback',
                icon: Icons.lightbulb_outline,
                child: Text(
                  result.feedback,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.replay),
                      label: const Text('Try Again'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.offAll(() => const SubjectsView()),
                      icon: const Icon(Icons.home),
                      label: const Text('Home'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
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
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }
}
