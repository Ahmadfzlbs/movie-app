import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final Color color;
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const Menu(
      {super.key,
      required this.color,
      required this.title,
      required this.imagePath,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Image.asset(imagePath),
          ),
        ),
        const SizedBox(height: 5),
        Text(title),
      ],
    );
  }
}
