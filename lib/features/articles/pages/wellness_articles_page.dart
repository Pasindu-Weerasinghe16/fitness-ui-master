import 'package:flutter/material.dart';

class WellnessArticlesPage extends StatelessWidget {
  const WellnessArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Image.asset(
              'assets/images/image005.jpg',
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
                      'WELLNESS',
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
                    'Sleep & Fitness Performance',
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
                        '7 min read',
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
                    'Your Secret Performance Weapon',
                    'You can have the perfect training program, dial in your nutrition to the gram, and optimize every supplement—but if you\'re not sleeping enough, you\'re leaving massive gains on the table. Sleep isn\'t just rest; it\'s when your body does its most important work. Let\'s explore why sleep might be the most underrated performance enhancer.',
                  ),
                  
                  _buildSection(
                    theme,
                    'What Happens During Sleep',
                    'While you\'re unconscious, your body is incredibly active:\n\nPhysical Recovery:\n• Growth hormone peaks (up to 75% of daily secretion)\n• Muscle protein synthesis accelerates\n• Tissue repair and cellular regeneration occur\n• Inflammatory markers decrease\n• Energy stores replenish\n\nNeurological Recovery:\n• Motor skills and movement patterns consolidate\n• Neural pathways strengthen\n• Metabolic waste products clear from the brain\n• Cognitive function and reaction time restore\n\nSkipping sleep is literally preventing your body from completing its recovery cycle.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Sleep Deprivation: The Performance Killer',
                    'Even moderate sleep restriction has devastating effects:\n\nPhysical Impact:\n• 10-30% decrease in time to exhaustion\n• Reduced peak and sustained muscle strength\n• Slower sprint times and reaction speed\n• Impaired coordination and motor control\n• Increased injury risk by up to 70%\n\nMetabolic Consequences:\n• Increased cortisol (stress hormone)\n• Decreased testosterone levels\n• Impaired glucose metabolism\n• Greater fat storage, reduced fat burning\n• Muscle protein breakdown exceeds synthesis\n\nOne week of sleeping 5 hours per night can decrease testosterone by 10-15%—equivalent to aging 10 years.',
                  ),
                  
                  _buildSection(
                    theme,
                    'How Much Sleep Do Athletes Need?',
                    'General Population: 7-9 hours\nActive Individuals: 8-9 hours\nAthletes in Heavy Training: 9-10 hours\n\nMore training volume = more recovery needed. Elite athletes often sleep 10+ hours daily, including naps. If you\'re training hard 5-6 days per week, you\'re an athlete—act like one.\n\nQuality matters as much as quantity. 7 hours of deep, uninterrupted sleep beats 9 hours of fragmented, poor-quality rest.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Sleep Architecture and Training',
                    'Sleep occurs in 90-minute cycles with distinct stages:\n\nNREM (Deep Sleep):\n• Physical restoration and growth\n• Immune system strengthening\n• Most critical for athletes\n• Dominates first half of night\n\nREM (Dream Sleep):\n• Cognitive recovery and memory\n• Motor skill consolidation\n• Emotional regulation\n• Increases in later sleep cycles\n\nThis is why going to bed late but "sleeping in" doesn\'t fully compensate—you miss crucial deep sleep windows that occur in the first 3-4 hours.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Optimizing Sleep for Performance',
                    'Create Your Sleep Sanctuary:\n• Cool temperature (65-68°F / 18-20°C)\n• Complete darkness (blackout curtains or eye mask)\n• Minimal noise (white noise if needed)\n• Comfortable, supportive mattress\n• Remove screens and work materials\n\nPre-Sleep Routine (60-90 minutes before bed):\n• Dim lights, activate "night mode" on devices\n• Avoid intense exercise or mental stimulation\n• Light stretching or meditation\n• Avoid large meals, caffeine, and alcohol\n• Cool shower (drops core body temperature)\n• Read or journal (non-stimulating activities)',
                  ),
                  
                  _buildSection(
                    theme,
                    'Strategic Napping',
                    'For hard-training athletes, strategic naps can enhance recovery:\n\n20-Minute Power Nap:\n• Boosts alertness and motor performance\n• No sleep inertia (grogginess)\n• Perfect pre-training\n\n90-Minute Full Cycle:\n• Complete sleep cycle including REM\n• Significant recovery benefits\n• Best for severe sleep debt\n\nTiming: Early afternoon (1-3 PM) is ideal. Late naps can disrupt nighttime sleep.',
                  ),
                  
                  _buildSection(
                    theme,
                    'The Non-Negotiables',
                    'Consistency is king. Your body thrives on routine:\n\n• Same bedtime and wake time (even weekends)\n• No caffeine after 2 PM (6-hour half-life)\n• Expose yourself to bright light in morning\n• Avoid alcohol close to bedtime (disrupts REM)\n• Finish intense training at least 3 hours before bed\n• Track sleep with wearables for accountability\n\nTreat your sleep schedule with the same discipline as your training schedule. One without the other is incomplete.',
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
                              Icons.bedtime,
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
                          '✓ Aim for 8-10 hours of quality sleep per night\n✓ Maintain consistent sleep and wake times daily\n✓ Create an optimal sleep environment (cool, dark, quiet)\n✓ Avoid caffeine after 2 PM and alcohol before bed\n✓ Finish intense workouts at least 3 hours before sleep\n✓ Use strategic naps (20 min or 90 min) for additional recovery\n✓ Track sleep quality to identify patterns and optimize\n✓ Remember: Sleep is when gains actually happen',
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
