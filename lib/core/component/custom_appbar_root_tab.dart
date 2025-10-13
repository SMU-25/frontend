import 'package:flutter/material.dart';

class CustomAppbarRootTab extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onPressed;
  final double height;

  const CustomAppbarRootTab({
    required this.title,
    required this.onPressed,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(title, style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.settings,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
