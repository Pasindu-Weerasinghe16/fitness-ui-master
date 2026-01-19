import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/shared/widgets/app_header.dart';
import 'package:fitness_flutter/services/user_profile_service.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static const _bgImage = 'assets/images/Sing in Sign Up photo.webp';
  static const _lime = Color(0xFFC8F902);
  static const _fieldBg = Color(0xFF1C1C1E);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms & Conditions'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = FirebaseAuth.instance;
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final currentUser = auth.currentUser;
      UserCredential credential;

      if (currentUser != null && currentUser.isAnonymous) {
        // Upgrade anonymous account by linking credentials, preserving the same uid.
        credential = await currentUser.linkWithCredential(
          EmailAuthProvider.credential(email: email, password: password),
        );
      } else {
        credential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      final name = _nameController.text.trim();
      final user = credential.user;
      if (user != null) {
        if (name.isNotEmpty) {
          await user.updateDisplayName(name);
        }
        await user.reload();

        await UserProfileService().save(
          uid: user.uid,
          displayName: name.isNotEmpty ? name : user.displayName,
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
            'Sign up failed (${e.code}): ${e.message ?? 'Please try again.'}',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign up failed. Please try again.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                    Colors.black.withOpacity(0.90),
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
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white.withOpacity(0.9),
                        ),
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
                              Text(
                                'Create An Account',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Create an account to set goals, track your progress, and stay motivated every step of the way.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.72),
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 22),

                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: fieldDecoration(
                                  hint: 'Name',
                                  icon: Icons.person_outline,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

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
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: !_isConfirmPasswordVisible,
                                style: const TextStyle(color: Colors.white),
                                decoration: fieldDecoration(
                                  hint: 'Confirm Password',
                                  icon: Icons.lock_outline,
                                  suffix: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white.withOpacity(0.75),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordVisible =
                                            !_isConfirmPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 14),

                              Row(
                                children: [
                                  Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _agreeToTerms = value ?? false;
                                      });
                                    },
                                    activeColor: _lime,
                                    checkColor: Colors.black,
                                    side: BorderSide(
                                      color: Colors.white.withOpacity(0.45),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _agreeToTerms = !_agreeToTerms;
                                        });
                                      },
                                      child: Text(
                                        'I agree to the Terms & Condition',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.white.withOpacity(0.70),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              SizedBox(
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleSignUp,
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
                                          'Create an Account',
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
                                    child: Divider(color: Colors.white.withOpacity(0.20)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      'Or Login with',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.white.withOpacity(0.60),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.white.withOpacity(0.20)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              _socialButton(
                                context,
                                label: 'Sign up with Google',
                                icon: Icons.g_mobiledata,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Google sign-up coming soon'),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.75),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: _lime,
                                    ),
                                    child: const Text(
                                      'Login',
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

  Widget _socialButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22, color: Colors.white.withOpacity(0.9)),
        label: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: _fieldBg.withOpacity(0.65),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
