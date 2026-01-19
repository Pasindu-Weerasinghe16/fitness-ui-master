import 'package:flutter/material.dart';

class TrainingArticlesPage extends StatelessWidget {
  const TrainingArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Image.asset(
              'assets/images/image002.jpg',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'TRAINING',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Article Title
                  Text(
                    'How to Build Muscle Effectively',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Meta Info
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '8 min read',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.person_outline,
                        size: 18,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Fitness Team',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  
                  // Article Content
                  _buildSection(
                    theme,
                    'The Science of Muscle Growth',
                    'Building muscle, scientifically known as hypertrophy, occurs when muscle fibers are damaged through resistance training and then repair themselves stronger and larger. This process requires three key elements: mechanical tension, muscle damage, and metabolic stress. Understanding these principles will transform your approach to training.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Progressive Overload: The Golden Rule',
                    'The most critical principle for muscle growth is progressive overload—gradually increasing the demands on your muscles over time. This can be achieved through:\n\n• Adding more weight to the bar\n• Increasing training volume (sets × reps)\n• Improving exercise form and range of motion\n• Reducing rest periods between sets\n• Increasing training frequency\n\nWithout progressive overload, your muscles have no reason to adapt and grow. Track your workouts religiously and aim to improve something every session.',
                  ),
                  
                  _buildSection(
                    theme,
                    'The Optimal Rep Range',
                    'While muscles can grow across various rep ranges, research shows different ranges offer unique benefits:\n\n• 1-5 reps: Primarily strength gains, minimal hypertrophy\n• 6-12 reps: The "sweet spot" for muscle growth\n• 12-20 reps: Muscular endurance with moderate growth\n• 20+ reps: Endurance focus, limited muscle building\n\nFor maximum muscle growth, focus most of your training in the 6-12 rep range, occasionally incorporating heavier (strength) and lighter (endurance) work.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Training Volume and Frequency',
                    'Research suggests optimal muscle growth occurs with:\n\n• 10-20 sets per muscle group per week\n• Training each muscle group 2-3 times per week\n• 48-72 hours recovery between sessions for the same muscle\n\nBeginners should start at the lower end (10-12 sets) and progressively increase volume as they adapt. More isn\'t always better—recovery is when muscles actually grow.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Exercise Selection Matters',
                    'Build your program around compound movements:\n\n• Squats (quads, glutes, core)\n• Deadlifts (posterior chain, back)\n• Bench Press (chest, shoulders, triceps)\n• Overhead Press (shoulders, triceps)\n• Pull-ups/Rows (back, biceps)\n\nThese exercises recruit multiple muscle groups, allow for heavy loading, and create the hormonal environment conducive to growth. Supplement with isolation exercises to target specific muscles.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Time Under Tension',
                    'The duration your muscles are under load during each set significantly impacts growth. Aim for:\n\n• 2-3 seconds on the eccentric (lowering) phase\n• 1-2 second pause at peak contraction\n• 1-2 seconds on the concentric (lifting) phase\n\nTotal time under tension should be 40-70 seconds per set for optimal hypertrophy. Slow, controlled movements beat explosive, momentum-driven reps every time.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Nutrition: The Building Blocks',
                    'You can\'t out-train a bad diet. Muscle growth requires:\n\n• Caloric surplus: 200-500 calories above maintenance\n• Protein: 0.8-1g per pound of body weight daily\n• Carbs: Fuel for intense training sessions\n• Fats: Support hormone production\n• Consistency: Every day counts, not just training days\n\nSpread protein intake across 4-6 meals throughout the day to maximize muscle protein synthesis.',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Key Takeaways Box
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.fitness_center,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Key Takeaways',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '✓ Apply progressive overload in every training session\n✓ Focus on 6-12 rep range for optimal muscle growth\n✓ Train each muscle group 2-3 times per week\n✓ Prioritize compound movements over isolation exercises\n✓ Maintain a slight caloric surplus with adequate protein\n✓ Sleep 7-9 hours nightly for proper recovery\n✓ Be patient—muscle building takes months, not weeks',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.7,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
