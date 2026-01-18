import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:fitness_flutter/app/shell/tabs.dart';
import 'package:fitness_flutter/app/theme/app_theme.dart';
import 'package:fitness_flutter/app/theme/theme_provider.dart';
import 'package:fitness_flutter/features/auth/pages/sign_in_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final user = snapshot.data;
              if (user != null && !user.isAnonymous) {
                return const Tabs();
              }
              return const SignInPage();
            },
          ),
        );
      },
    );
  }
}
