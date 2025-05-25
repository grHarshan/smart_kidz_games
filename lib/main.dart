import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(KidsGameApp());

class KidsGameApp extends StatelessWidget {
  const KidsGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Games',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'ComicSans'),
      home: HomePage(),
    );
  }
}
