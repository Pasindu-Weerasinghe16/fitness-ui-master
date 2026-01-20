import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF007AFF), Color(0xFF5AC8FA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF007AFF).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              // App Name
              Text(
                'Fitness Tracker',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              // Version
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'Version 1.0.0',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Description Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'About This App',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fitness Tracker is your all-in-one companion for achieving your health and fitness goals. Track workouts, monitor nutrition, set goals, and stay motivated with personalized insights.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Built with Flutter and powered by Firebase, this app provides a seamless cross-platform experience with real-time data synchronization.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Features Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.stars,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Key Features',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      theme,
                      icon: Icons.fitness_center,
                      title: 'Workout Tracking',
                      description: 'Track exercises, sets, reps, and calories',
                    ),
                    _buildFeatureItem(
                      theme,
                      icon: Icons.restaurant_menu,
                      title: 'Nutrition Logging',
                      description: 'Log meals and monitor calorie intake',
                    ),
                    _buildFeatureItem(
                      theme,
                      icon: Icons.insights,
                      title: 'Progress Insights',
                      description: 'Visualize your fitness journey with charts',
                    ),
                    _buildFeatureItem(
                      theme,
                      icon: Icons.emoji_events,
                      title: 'Gamification',
                      description: 'Earn badges and unlock achievements',
                    ),
                    _buildFeatureItem(
                      theme,
                      icon: Icons.calculate,
                      title: 'BMI & Body Metrics',
                      description: 'Track body measurements and BMI',
                    ),
                    _buildFeatureItem(
                      theme,
                      icon: Icons.cloud_sync,
                      title: 'Cloud Sync',
                      description: 'Access your data across all devices',
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Developer Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.code,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Development',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(theme, 'Developer', 'Fitness Tech Team'),
                    _buildInfoRow(theme, 'Framework', 'Flutter 3.0+'),
                    _buildInfoRow(theme, 'Backend', 'Firebase'),
                    _buildInfoRow(theme, 'Platform', 'iOS, Android, Web', isLast: true),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Contact & Legal Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.gavel,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Legal & Contact',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildLinkItem(
                      theme,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening Privacy Policy...')),
                        );
                      },
                    ),
                    _buildLinkItem(
                      theme,
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening Terms of Service...')),
                        );
                      },
                    ),
                    _buildLinkItem(
                      theme,
                      icon: Icons.security_outlined,
                      title: 'Licenses',
                      onTap: () {
                        showLicensePage(
                          context: context,
                          applicationName: 'Fitness Tracker',
                          applicationVersion: '1.0.0',
                          applicationIcon: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF007AFF), Color(0xFF5AC8FA)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildLinkItem(
                      theme,
                      icon: Icons.email_outlined,
                      title: 'Contact Support',
                      subtitle: 'support@fitnessapp.com',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email: support@fitnessapp.com'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Copyright
              Text(
                '© 2026 Fitness Tracker. All rights reserved.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Made with ❤️ using Flutter',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem(
    ThemeData theme, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: theme.textTheme.bodySmall?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
