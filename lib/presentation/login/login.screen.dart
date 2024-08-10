import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import 'components/my_button.dart';
import 'components/my_textfield.dart';
import 'controllers/login.controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login e-Tix'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Image.asset(
                "assets/images/ticket-100.png",
                height: 200,
                width: 200,
              ),
              MyTextField(
                  obsecureText: false,
                  controller: controller.usernameC,
                  hintText: "Username",
                  icon: const Icon(Icons.person)),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                  obsecureText: true,
                  controller: controller.pwC,
                  hintText: "Password",
                  icon: const Icon(Icons.lock)),
              const SizedBox(
                height: 30,
              ),
              MyButton(
                  text: const Text(
                    "Login",
                    style: TextStyle(color: whiteColor),
                  ),
                  onPressed: () {
                    controller.login();
                  }),
            ],
          ),
        ));
  }
}
