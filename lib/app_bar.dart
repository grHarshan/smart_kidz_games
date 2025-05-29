import 'package:flutter/material.dart';
import 'package:mad_game/profile.dart';


class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onHomePressed;
  final VoidCallback? onProfilePressed;
  //final String parentName;  
  //final String kidName;

  const SimpleAppBar({
    Key? key,
    this.onHomePressed,
    this.onProfilePressed,
    //required this.parentName, 
    //required this.kidName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(211, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            IconButton(
              icon: const Icon(Icons.home, color: Color.fromARGB(255, 227, 187, 64)),
              onPressed: onHomePressed,
            ),

            
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/logo_word.png',
                  height: 30,
                ),
              ),
            ),

            IconButton(
  icon: const Icon(Icons.person, color: Color.fromARGB(255, 227, 187, 64)),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  },
),

          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
