import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'start_page.dart';
import 'theme_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const KidsGameApp(),
    ),
  );
}

class KidsGameApp extends StatelessWidget {
  const KidsGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Kids Games',
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.currentTheme,
          home: StartPage(),
        );
      },
    );
  }
}
