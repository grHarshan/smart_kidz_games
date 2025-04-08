import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(KidsGameApp());

class KidsGameApp extends StatelessWidget {
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
