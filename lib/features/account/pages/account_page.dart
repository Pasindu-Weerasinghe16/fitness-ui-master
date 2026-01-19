import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:fitness_flutter/features/profile/pages/personal_details_page.dart';
import 'package:fitness_flutter/shared/widgets/Header.dart';
import 'package:fitness_flutter/app/theme/theme_provider.dart';
import 'package:fitness_flutter/features/auth/pages/sign_in_page.dart';
import 'package:fitness_flutter/features/auth/pages/sign_up_page.dart';
import 'package:fitness_flutter/services/user_profile_service.dart';
import 'package:go_router/go_router.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  String _userDisplayName(User? user) {
    final displayName = user?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) return displayName;
    final email = user?.email?.trim();
    if (email != null && email.isNotEmpty) {
      final atIndex = email.indexOf('@');
      return atIndex > 0 ? email.substring(0, atIndex) : email;
    }
    return 'Guest';
  }

  String _profileDisplayName(User? user, UserProfile? profile) {
    final pName = profile?.displayName?.trim();
    if (pName != null && pName.isNotEmpty) return pName;
    return _userDisplayName(user);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final profileService = UserProfileService();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header('Account'),
              const SizedBox(height: 20),
              
              // Profile Card
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
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<UserProfile?>(
                            stream: user == null ? const Stream.empty() : profileService.watch(user.uid),
                            builder: (context, snapshot) {
                              return Text(
                                _profileDisplayName(user, snapshot.data),
                                style: theme.textTheme.titleLarge,
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'Not signed in',
                            style: theme.textTheme.bodyMedium,
                          ),
                          if (user != null) ...[
                            const SizedBox(height: 8),
                            StreamBuilder<UserProfile?>(
                              stream: profileService.watch(user.uid),
                              builder: (context, snapshot) {
                                final profile = snapshot.data;
                                final height = profile?.heightCm;
                                final weight = profile?.weightKg;

                                final items = <String>[];
                                if (height != null) items.add('Height: ${height.toString()} cm');
                                if (weight != null) items.add('Weight: ${weight.toString()} kg');

                                if (items.isEmpty) {
                                  return Text(
                                    'Add your height & weight',
                                    style: theme.textTheme.bodySmall,
                                  );
                                }

                                return Text(
                                  items.join(' • '),
                                  style: theme.textTheme.bodySmall,
                                );
                              },
                            ),
                          ],
                          if (user != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  user.emailVerified
                                      ? Icons.verified
                                      : Icons.error_outline,
                                  size: 16,
                                  color: user.emailVerified
                                      ? Colors.green
                                      : theme.colorScheme.error,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  user.emailVerified
                                      ? 'Email verified'
                                      : 'Email not verified',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      Icons.edit,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Account Settings Section
              Text(
                'Account Settings',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 12),

              if (user != null && user.isAnonymous) ...[
                _buildSettingsTile(
                  context,
                  icon: Icons.login,
                  title: 'Upgrade account',
                  subtitle: 'Sign in with email to keep your data',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (sheetContext) {
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.person_add_alt_1),
                                  title: const Text('Create account'),
                                  subtitle: const Text('Link this device account to email/password'),
                                  onTap: () {
                                    Navigator.pop(sheetContext);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const SignUpPage()),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.login),
                                  title: const Text('Sign in'),
                                  subtitle: const Text('Use an existing email/password account'),
                                  onTap: () {
                                    Navigator.pop(sheetContext);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const SignInPage()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
              
              _buildSettingsTile(
                context,
                icon: Icons.person_outline,
                title: 'Personal Details',
                subtitle: 'Age, height, weight & goals',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonalDetailsPage(),
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Reminders & alerts',
              ),
              _buildSettingsTile(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy & Security',
                subtitle: 'Data & permissions',
              ),
              _buildSettingsTile(
                context,
                icon: Icons.payment_outlined,
                title: 'Subscription',
                subtitle: 'Premium plan',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Gold',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // App Settings Section
              Text(
                'App Settings',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 12),
              
              _buildSettingsTile(
                context,
                icon: Icons.sync,
                title: 'Sync Devices',
                subtitle: 'Connect wearables',
              ),
              _buildSettingsTile(
                context,
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
              ),
              _buildSettingsTile(
                context,
                icon: Icons.dark_mode_outlined,
                title: 'Theme',
                subtitle: Provider.of<ThemeProvider>(context).isDarkMode ? 'Dark mode' : 'Light mode',
                onTap: () {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
                trailing: Switch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                  activeColor: theme.colorScheme.primary,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Support Section
              Text(
                'Support',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 12),
              
              _buildSettingsTile(
                context,
                icon: Icons.help_outline,
                title: 'Help Center',
                subtitle: 'FAQs & tutorials',
              ),
              _buildSettingsTile(
                context,
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                subtitle: 'Share your thoughts',
              ),
              _buildSettingsTile(
                context,
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'Version 1.0.0',
              ),
              
              const SizedBox(height: 24),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final parentContext = context;

    showDialog<void>(
      context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                try {
                  await FirebaseAuth.instance.signOut();
                  if (!parentContext.mounted) return;
                  parentContext.go('/sign-in');
                } on FirebaseAuthException catch (e) {
                  if (!parentContext.mounted) return;
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.message ?? 'Logout failed. Please try again.',
                      ),
                    ),
                  );
                } catch (_) {
                  if (!parentContext.mounted) return;
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    const SnackBar(
                      content: Text('Logout failed. Please try again.'),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(parentContext).colorScheme.error,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
