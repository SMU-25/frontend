import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppbar({
    required this.title,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppBar(
          toolbarHeight: 70,
          iconTheme: IconThemeData(
            size: 30,
            color: Colors.black,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          centerTitle: true,
          actions: actions,
        ),
      ],
    );
  }
}
