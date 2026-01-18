import 'package:flutter/material.dart';

class NutritionArticlesPage extends StatelessWidget {
  const NutritionArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Image.asset(
              'assets/images/image001.jpg',
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
                      'NUTRITION',
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
                    'Pre-Workout Nutrition Guide',
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
                        '5 min read',
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
                    'Why Pre-Workout Nutrition Matters',
                    'What you eat before exercising can significantly impact your performance, endurance, and recovery. The right pre-workout meal provides your body with the fuel it needs to power through intense training sessions while preventing muscle breakdown.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Timing is Everything',
                    'The optimal time to eat before your workout depends on the size and composition of your meal:\n\n• Large meals (300-500 calories): 2-3 hours before\n• Small meals (150-250 calories): 1-2 hours before\n• Light snacks (under 150 calories): 30-60 minutes before\n\nThis timing allows for proper digestion and ensures nutrients are available when your body needs them most.',
                  ),
                  
                  _buildSection(
                    theme,
                    'The Perfect Pre-Workout Macros',
                    'A balanced pre-workout meal should include:\n\nCarbohydrates (60-70%): Your primary energy source. Choose complex carbs like oatmeal, brown rice, or whole wheat bread for sustained energy release.\n\nProtein (20-30%): Helps prevent muscle breakdown and supports recovery. Opt for lean sources like chicken, Greek yogurt, or protein powder.\n\nHealthy Fats (10-15%): Provides long-lasting energy, especially for endurance activities. Include small amounts of nuts, avocado, or nut butter.',
                  ),
                  
                  _buildSection(
                    theme,
                    'Top Pre-Workout Meal Ideas',
                    '2-3 Hours Before:\n• Grilled chicken with sweet potato and vegetables\n• Brown rice bowl with lean turkey and spinach\n• Whole wheat pasta with marinara sauce and lean protein\n\n1-2 Hours Before:\n• Greek yogurt with berries and granola\n• Banana with almond butter on whole grain toast\n• Protein smoothie with oats and fruit\n\n30-60 Minutes Before:\n• Apple slices with a small handful of almonds\n• Rice cakes with honey\n• Energy bar (low fiber, easily digestible)',
                  ),
                  
                  _buildSection(
                    theme,
                    'Hydration is Key',
                    'Don\'t forget about proper hydration! Drink 16-20 ounces of water 2-3 hours before your workout, then another 8-10 ounces 15-30 minutes before starting. For intense or long-duration workouts, consider adding electrolytes to your pre-workout hydration strategy.',
                  ),
                  
                  _buildSection(
                    theme,
                    'What to Avoid',
                    'Steer clear of:\n• High-fat foods that slow digestion\n• Excessive fiber that may cause GI discomfort\n• New foods you haven\'t tried before\n• Large portions that make you feel sluggish\n• Sugary snacks that cause energy crashes',
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
                              Icons.lightbulb_outline,
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
                          '✓ Fuel up 2-3 hours before with complex carbs and lean protein\n✓ Stay properly hydrated starting hours before your workout\n✓ Choose easily digestible foods to avoid GI discomfort\n✓ Experiment during training to find what works for your body\n✓ Consistency in your pre-workout nutrition leads to better performance',
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
