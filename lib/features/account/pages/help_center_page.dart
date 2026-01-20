import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Help Center'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF007AFF), Color(0xFF5AC8FA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Frequently Asked Questions',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Find answers to common questions',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Getting Started Section
              _buildSectionTitle(theme, 'Getting Started'),
              const SizedBox(height: 12),
              _buildFAQItem(
                theme,
                question: 'How do I create an account?',
                answer:
                    'Tap on "Sign Up" on the login screen. Enter your email, create a password, and follow the prompts to set up your profile. You can also sign up using your Google account for quick access.',
              ),
              _buildFAQItem(
                theme,
                question: 'How do I track my workouts?',
                answer:
                    'Go to the Workouts tab, select a workout program, and start your session. The app will automatically track your duration, calories burned, and progress. You can also log custom workouts manually.',
              ),
              _buildFAQItem(
                theme,
                question: 'Can I use the app offline?',
                answer:
                    'Yes! Once you\'ve downloaded workout plans and synced your data, you can use most features offline. Your progress will be saved locally and synced when you reconnect to the internet.',
              ),

              const SizedBox(height: 24),

              // Account & Profile Section
              _buildSectionTitle(theme, 'Account & Profile'),
              const SizedBox(height: 12),
              _buildFAQItem(
                theme,
                question: 'How do I change my subscription plan?',
                answer:
                    'Go to Account > Subscription, then tap on the plan badge to see available options (Gold, Silver, Bronze). Select your preferred plan to upgrade or downgrade.',
              ),
              _buildFAQItem(
                theme,
                question: 'How do I update my personal details?',
                answer:
                    'Navigate to Account > Personal Details. Here you can update your name, height, weight, and body measurements. Changes are saved automatically to Firebase.',
              ),
              _buildFAQItem(
                theme,
                question: 'How do I reset my password?',
                answer:
                    'On the login screen, tap "Forgot Password?" and enter your email. You\'ll receive a password reset link. Follow the instructions in the email to create a new password.',
              ),

              const SizedBox(height: 24),

              // Fitness Tracking Section
              _buildSectionTitle(theme, 'Fitness Tracking'),
              const SizedBox(height: 12),
              _buildFAQItem(
                theme,
                question: 'How is BMI calculated?',
                answer:
                    'BMI (Body Mass Index) is calculated using the formula: weight (kg) / height (m)². The app automatically calculates your BMI when you enter your height and weight in Personal Details.',
              ),
              _buildFAQItem(
                theme,
                question: 'How do I set fitness goals?',
                answer:
                    'Visit the Goals tab to set your weekly workout targets, calorie goals, and weight targets. The app will track your progress and send reminders to help you stay on track.',
              ),
              _buildFAQItem(
                theme,
                question: 'What do the body measurement categories mean?',
                answer:
                    'Body measurements (chest, waist, arms, thighs) are categorized as Low, Normal, or High based on typical adult ranges. These are general guidelines and can vary based on fitness level and body type.',
              ),

              const SizedBox(height: 24),

              // Nutrition Section
              _buildSectionTitle(theme, 'Nutrition'),
              const SizedBox(height: 12),
              _buildFAQItem(
                theme,
                question: 'How do I log my meals?',
                answer:
                    'Go to the Diet tab and tap the "+" button to add a meal. You can choose from our meal database or create custom entries with your own calorie and macro information.',
              ),
              _buildFAQItem(
                theme,
                question: 'Are meal plans personalized?',
                answer:
                    'Yes! The app generates meal plans based on your daily calorie goals, dietary preferences, and fitness objectives. Plans are updated weekly and can be customized.',
              ),

              const SizedBox(height: 24),

              // Technical Support Section
              _buildSectionTitle(theme, 'Technical Support'),
              const SizedBox(height: 12),
              _buildFAQItem(
                theme,
                question: 'The app is crashing, what should I do?',
                answer:
                    'Try restarting the app first. If the issue persists, clear the app cache in your device settings or reinstall the app. Make sure you\'re using the latest version.',
              ),
              _buildFAQItem(
                theme,
                question: 'My data is not syncing, how do I fix it?',
                answer:
                    'Check your internet connection and ensure you\'re logged in. Go to Account > Sync Devices to manually trigger a sync. If problems continue, try logging out and back in.',
              ),
              _buildFAQItem(
                theme,
                question: 'How do I change the app language?',
                answer:
                    'Go to Account > App Settings > Language. Select your preferred language (English or Chinese) from the list. The app will update immediately.',
              ),

              const SizedBox(height: 32),

              // Contact Support Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.support_agent,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Still need help?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Contact our support team for personalized assistance',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Show contact options or email
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email: support@fitnessapp.com'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                      icon: const Icon(Icons.email_outlined),
                      label: const Text('Contact Support'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildFAQItem(ThemeData theme,
      {required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.help_outline,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          title: Text(
            question,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Text(
              answer,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
