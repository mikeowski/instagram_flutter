import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';

import 'package:instagram_flutter/widgets/text_field_input.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
  }

  void sendVerificationEmail() async {
    if (_emailController.text == '') {
      showSnackBar('please write your email', context);
    }
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().forgotPassword(_emailController.text);
    setState(() {
      _isLoading = false;
    });
    if (res == 'Success') {
      showSnackBar('email sended', context);
      navigateToLoginScreen();
    } else {
      showSnackBar(res, context);
    }
  }

  void navigateToLoginScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Flexible(
            child: Container(),
          ),
          //SVG image
          SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 64,
          ),
          const SizedBox(
            height: 64,
          ),
          // Circular widget to accept and shown our selected file

          // Text field imput for email
          TextFieldInput(
              textEditingController: _emailController,
              hintText: "Enter your email",
              textInputType: TextInputType.emailAddress),
          const SizedBox(
            height: 24,
          ),

          Flexible(child: Container()),
          //button login
          InkWell(
            onTap: sendVerificationEmail,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Container(
                    child: const Text("Send Email"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor,
                    ),
                  ),
          ),

          Flexible(
            child: Container(),
          ),
          InkWell(
            onTap: navigateToLoginScreen,
            child: Container(
              child: const Text(
                'Log In',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              padding: const EdgeInsets.only(bottom: 20),
            ),
          ),
        ]),
      ),
    ));
  }
}
