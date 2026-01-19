import 'package:flutter/material.dart';

class MotivationArticlesPage extends StatelessWidget {
  const MotivationArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Image.asset(
              'assets/images/image004.jpg',
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
                      'MOTIVATION',
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
                    'Stay Consistent: 7 Tips',
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
                        '4 min read',
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
                  
                  // Introduction
                  Text(
                    'Consistency beats perfection every single time. The person who shows up 80% ready but does it 365 days a year will always outperform someone who gives 100% for two weeks then disappears. Here are seven powerful strategies to build unbreakable consistency in your fitness journey.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.7,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Article Content
                  _buildTip(
                    theme,
                    '1',
                    'Start Ridiculously Small',
                    'The biggest mistake? Starting too big. Want to work out? Start with just 5 minutes. Seriously. Five minutes is better than zero, and it builds the habit without overwhelming you. Once the habit is locked in, increasing duration becomes natural. Remember: You\'re building a system, not chasing motivation.',
                  ),
                  
                  _buildTip(
                    theme,
                    '2',
                    'Schedule It Like a Meeting',
                    'If it\'s not on your calendar, it doesn\'t exist. Treat your workouts like important business meetings—non-negotiable appointments with yourself. Same time, same place, every day if possible. This removes decision fatigue and transforms exercise from a choice into a routine.',
                  ),
                  
                  _buildTip(
                    theme,
                    '3',
                    'Remove All Friction',
                    'Make it embarrassingly easy to start. Sleep in your workout clothes. Put your gym shoes by the door. Pre-pack your gym bag the night before. Every obstacle you remove is one less excuse your brain can manufacture at 6 AM when your alarm goes off.',
                  ),
                  
                  _buildTip(
                    theme,
                    '4',
                    'Track Your Streak',
                    'There\'s something magical about not wanting to break a streak. Get a calendar and mark an X for every day you complete your workout. After a week, you won\'t want to break the chain. After a month, the streak becomes more motivating than the workout itself. This simple visual makes progress undeniable.',
                  ),
                  
                  _buildTip(
                    theme,
                    '5',
                    'Find Your Tribe',
                    'Accountability multiplies consistency. Whether it\'s a workout partner, an online community, or a coach, having people who expect to see you makes showing up easier. You\'ll push through days you\'d otherwise skip just to not let them down. Social pressure works—use it to your advantage.',
                  ),
                  
                  _buildTip(
                    theme,
                    '6',
                    'Embrace "Good Enough" Days',
                    'Not every workout will be perfect, and that\'s fine. Some days, you\'ll hit new PRs. Other days, just showing up is the victory. Have a "minimum viable workout" ready for tough days—maybe it\'s just a 10-minute walk or some stretching. Doing something keeps the habit alive.',
                  ),
                  
                  _buildTip(
                    theme,
                    '7',
                    'Celebrate the Process, Not Just Results',
                    'Results take time. If you only celebrate the end goal, you\'ll quit before getting there. Instead, celebrate showing up. Celebrate completing the workout even when you didn\'t feel like it. Celebrate consistency itself. These small wins compound into massive transformation over time.',
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Closing Section
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
                              Icons.psychology_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'The Bottom Line',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Motivation is fleeting. Discipline is reliable. Systems beat goals. You don\'t need to feel motivated every day—you need a routine so solid that you show up regardless of how you feel. Start small, remove friction, track progress, and never underestimate the power of just showing up. In six months, you won\'t recognize yourself.',
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

  Widget _buildTip(ThemeData theme, String number, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
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
                const SizedBox(height: 8),
                Text(
                  content,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.7,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
