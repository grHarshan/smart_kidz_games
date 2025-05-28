import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onHomePressed;
  final VoidCallback? onProfilePressed;

  const SimpleAppBar({
    Key? key,
    this.onHomePressed,
    this.onProfilePressed,
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
              icon: const Icon(Icons.home, color: Colors.amber),
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

            // Profile button
            IconButton(
              icon: const Icon(Icons.person, color: Colors.amber),
              onPressed: onProfilePressed,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
