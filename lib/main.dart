import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:fitness_flutter/app/app.dart';
import 'package:fitness_flutter/app/theme/theme_provider.dart';
import 'package:fitness_flutter/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Keep user data available across app restarts.
  // On web, persistence uses IndexedDB (when supported).
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

  debugPrint('Firebase user uid: ${FirebaseAuth.instance.currentUser?.uid}');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}




