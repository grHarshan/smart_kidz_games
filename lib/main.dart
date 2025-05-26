import 'package:flutter/material.dart';
import 'start_page.dart';

void main() => runApp(KidsGameApp());

class KidsGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Games',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'ComicSans'),
      home: StartPage(),
    );
  }
}
