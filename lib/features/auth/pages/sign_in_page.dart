import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fitness_flutter/services/user_profile_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  static const _bgImage = 'assets/images/Sing in Sign Up photo.webp';
  static const _lime = Color(0xFFC8F902);
  static const _fieldBg = Color(0xFF1C1C1E);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final auth = FirebaseAuth.instance;
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final currentUser = auth.currentUser;
      UserCredential credential;

      if (currentUser != null && currentUser.isAnonymous) {
        try {
          credential = await currentUser.linkWithCredential(
            EmailAuthProvider.credential(email: email, password: password),
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'credential-already-in-use' ||
              e.code == 'email-already-in-use') {
            await auth.signOut();
            credential = await auth.signInWithEmailAndPassword(
              email: email,
              password: password,
            );
          } else {
            rethrow;
          }
        }
      } else {
        credential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      final user = credential.user;
      if (user != null) {
        await user.reload();
        await UserProfileService().save(
          uid: user.uid,
          displayName: user.displayName,
          email: user.email,
        );
      }

      if (!mounted) return;
      context.go('/tabs');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sign in failed (${e.code}): ${e.message ?? 'Please try again.'}',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in failed. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() => _isLoading = true);
    try {
      final auth = FirebaseAuth.instance;
      final credential = await auth.signInAnonymously();
      final user = credential.user;
      if (user != null) {
        await UserProfileService().save(
          uid: user.uid,
          displayName: user.displayName,
          email: user.email,
        );
      }

      if (!mounted) return;
      context.go('/tabs');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Guest sign in failed (${e.code}): ${e.message ?? 'Please try again.'}',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guest sign in failed. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _comingSoon(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider sign-in coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    InputDecoration fieldDecoration({
      required String hint,
      required IconData icon,
      Widget? suffix,
    }) {
      return InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.white.withOpacity(0.55),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.75)),
        suffixIcon: suffix,
        filled: true,
        fillColor: _fieldBg.withOpacity(0.92),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: _lime.withOpacity(0.9), width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.2),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _bgImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.45),
                    Colors.black.withOpacity(0.88),
                  ],
                  stops: const [0.0, 0.75],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isLoading ? null : _continueAsGuest,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white.withOpacity(0.9),
                        ),
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 8),
                              Center(
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.10),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.10),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.fitness_center,
                                    color: _lime,
                                    size: 44,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                "Let's Login you in",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Log in to pick up where you left off. Your habits, streaks, and progress are waiting for you.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.72),
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 22),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                decoration: fieldDecoration(
                                  hint: 'Email',
                                  icon: Icons.email_outlined,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                style: const TextStyle(color: Colors.white),
                                decoration: fieldDecoration(
                                  hint: 'Password',
                                  icon: Icons.lock_outline,
                                  suffix: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white.withOpacity(0.75),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Password reset coming soon'),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white.withOpacity(0.85),
                                  ),
                                  child: const Text('Forgot password?'),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleSignIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _lime,
                                    foregroundColor: Colors.black,
                                    disabledBackgroundColor: _lime.withOpacity(0.45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black,
                                          ),
                                        )
                                      : const Text(
                                          'Login with Email',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white.withOpacity(0.20),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      'Or continue with',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.white.withOpacity(0.60),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white.withOpacity(0.20),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _SocialCircleButton(
                                    backgroundColor: _fieldBg.withOpacity(0.65),
                                    onPressed: () => _comingSoon('Google'),
                                    child: const Icon(Icons.g_mobiledata, size: 28),
                                  ),
                                  const SizedBox(width: 14),
                                  _SocialCircleButton(
                                    backgroundColor: _fieldBg.withOpacity(0.65),
                                    onPressed: () => _comingSoon('Facebook'),
                                    child: const Icon(Icons.facebook, size: 22),
                                  ),
                                  const SizedBox(width: 14),
                                  _SocialCircleButton(
                                    backgroundColor: _fieldBg.withOpacity(0.65),
                                    onPressed: () => _comingSoon('Apple'),
                                    child: const Icon(Icons.apple, size: 22),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                height: 50,
                                child: OutlinedButton.icon(
                                  onPressed: _isLoading ? null : _continueAsGuest,
                                  icon: Icon(
                                    Icons.person_outline,
                                    size: 22,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  label: Text(
                                    'Continue as Guest',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: _fieldBg.withOpacity(0.65),
                                    side: BorderSide(
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.75),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => context.push('/sign-up'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: _lime,
                                    ),
                                    child: const Text(
                                      'Create an account',
                                      style: TextStyle(fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

class _SocialCircleButton extends StatelessWidget {
  const _SocialCircleButton({
    required this.child,
    required this.onPressed,
    required this.backgroundColor,
  });

  final Widget child;
  final VoidCallback onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onPressed,
      radius: 28,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.10)),
        ),
        child: IconTheme(
          data: IconThemeData(color: Colors.white.withOpacity(0.92)),
          child: Center(child: child),
        ),
      ),
    );
  }
}
