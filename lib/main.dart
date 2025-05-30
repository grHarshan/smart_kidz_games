import 'package:flutter/material.dart';
import 'package:mad_game/Login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'start_page.dart';
import 'theme_notifier.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final startWithSignup = prefs.getBool('startWithSignup') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: KidsGameApp(startWithSignup: startWithSignup),
    ),
  );
}

class KidsGameApp extends StatelessWidget {
  final bool startWithSignup;

  const KidsGameApp({super.key, required this.startWithSignup});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Kids Games',
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.currentTheme,
          home: startWithSignup ? const LoginPage() : const StartPage(),
        );
      },
    );
  }
}
