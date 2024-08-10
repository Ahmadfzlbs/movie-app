import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';

class MyButton extends StatelessWidget {
  final Text text;
  final VoidCallback onPressed;
  const MyButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            fixedSize: Size(Get.width, 50), backgroundColor: blackColor),
        child: text,
      ),
    );
  }
}
