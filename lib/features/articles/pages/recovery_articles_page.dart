import 'package:flutter/material.dart';

class RecoveryArticlesPage extends StatelessWidget {
  const RecoveryArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recovery'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Image.asset(
              'assets/images/image003.jpg',
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
                      'RECOVERY',
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
                    'The Importance of Rest Days',
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
                        '6 min read',
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
                    'Rest is Not Laziness—It\'s Strategic',
                    'Many fitness enthusiasts believe that more training equals better results. This couldn\'t be further from the truth. Your muscles don\'t grow in the gym—they grow during rest. Understanding this fundamental principle can transform your training results and prevent burnout.',
                  ),
                  
                  _buildSection(
                    theme,
                    'What Happens During Recovery',
                    'When you exercise, you create microscopic tears in your muscle fibers. This damage triggers a complex repair process:\n\n• Inflammation marks damaged tissue for repair\n• Satellite cells activate and fuse to muscle fibers\n• Protein synthesis increases to rebuild stronger tissue\n• Glycogen stores replenish in muscle cells\n• Nervous system recalibrates for improved coordination\n\nThis entire process takes 24-72 hours depending on workout intensity. Without adequate rest, you\'re constantly breaking down tissue without giving your body time to rebuild stronger.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Signs You Need a Rest Day',
                    'Your body sends clear signals when it needs recovery:\n\n• Persistent muscle soreness lasting 48+ hours\n• Decreased performance despite effort\n• Elevated resting heart rate\n• Difficulty sleeping or disrupted sleep patterns\n• Mood changes, irritability, or lack of motivation\n• Increased susceptibility to colds and infections\n• Chronic fatigue that coffee can\'t fix\n\nIgnoring these signs leads to overtraining syndrome—a state where performance declines despite continued or increased training.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Active vs. Passive Recovery',
                    'Rest days don\'t mean lying on the couch all day (though sometimes you should).\n\nPassive Recovery:\n• Complete rest from physical activity\n• Ideal after very intense training weeks\n• Includes massage, stretching, meditation\n• Focus on sleep, hydration, and nutrition\n\nActive Recovery:\n• Light movement promoting blood flow\n• Walking, swimming, yoga, or cycling at 40-50% effort\n• Helps reduce muscle soreness (DOMS)\n• Accelerates waste removal from muscles\n\nMost athletes benefit from a mix of both throughout their training week.',
                  ),
                  
                  _buildSection(
                    theme,
                    'How Many Rest Days Do You Need?',
                    'The answer depends on several factors:\n\nBeginners: 2-3 rest days per week\n• Your body is adapting to new stimulus\n• Higher injury risk without adequate recovery\n• Building foundational strength and work capacity\n\nIntermediate: 1-2 rest days per week\n• Better recovery capacity developed\n• Can handle higher training frequency\n• Strategic deload weeks every 4-6 weeks\n\nAdvanced: 1 rest day per week (minimum)\n• Superior recovery mechanisms\n• Often incorporate active recovery sessions\n• Still need periodic complete rest\n\nRemember: More training is beneficial only if you can recover from it.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Maximizing Recovery Quality',
                    'Make your rest days count:\n\nSleep: 7-9 hours of quality sleep is non-negotiable. This is when growth hormone peaks and most recovery occurs.\n\nNutrition: Don\'t slash calories on rest days. Your body needs fuel to repair. Maintain protein intake and include anti-inflammatory foods.\n\nHydration: Continue drinking water. Aim for half your body weight in ounces daily.\n\nStress Management: Psychological stress impairs physical recovery. Practice meditation, deep breathing, or journaling.\n\nMobility Work: Gentle stretching and foam rolling improve circulation and reduce muscle tension without creating new stress.',
                  ),
                  
                  _buildSection(
                    theme,
                    'The Mental Benefits',
                    'Rest days aren\'t just physical recovery—they\'re crucial for mental health:\n\n• Prevents mental burnout and exercise addiction\n• Allows you to miss training (building appreciation)\n• Reduces cortisol and stress hormones\n• Improves motivation for future workouts\n• Creates sustainable long-term habits\n\nThe most successful athletes view rest as part of their training, not a break from it.',
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
                              Icons.hotel,
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
                          '✓ Muscles grow during rest, not during training\n✓ Take 1-3 rest days per week based on experience level\n✓ Listen to your body—persistent soreness means you need rest\n✓ Incorporate both active and passive recovery strategies\n✓ Prioritize 7-9 hours of quality sleep every night\n✓ Maintain proper nutrition on rest days for optimal repair\n✓ View recovery as an essential part of your training program',
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
