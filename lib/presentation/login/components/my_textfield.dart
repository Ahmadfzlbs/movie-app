import 'package:flutter/material.dart';
import '../../../constants.dart';

class MyTextField extends StatelessWidget {
  final Icon icon;
  final bool obsecureText;
  final String hintText;
  final TextEditingController controller;

  const MyTextField(
      {super.key,
      required this.obsecureText,
      required this.controller,
      required this.hintText,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        obscureText: obsecureText,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: greyColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: blackColor)),
        ),
      ),
    );
  }
}
