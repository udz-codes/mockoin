import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'package:mockoin/components/logo_header.dart';
import 'package:mockoin/components/text_input_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mockoin/services/user_service.dart';

class LoginScreen extends StatelessWidget {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UserService user = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kColorLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kColorLight,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.close,
                size: 25,
                color: kColorGreen,
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                const Text(
                  'Login',
                  style: kHeadingStyle,
                ),
                const SizedBox(height: 30,),
                TextInputBar(
                  placeholder: 'Email',
                  controller: emailController
                ),
                const SizedBox(height: 10,),
                TextInputBar(
                  placeholder: 'Password',
                  controller: passwordController,
                  obscureText: true,
                  inputAction: TextInputAction.done,
                ),
                const SizedBox(height: 10,),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Register',
                        style: const TextStyle(color: kColorGreen),
                        recognizer: TapGestureRecognizer()..onTap = () => print('Register')
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                RawMaterialButton(
                  onPressed: () async {
                    var response  = await user.login(
                      email: emailController.text,
                      password: passwordController.text
                    );

                    print(response.body);
                  },
                  fillColor: kColorBlue,
                  child: const Icon(
                    LineIcons.check,
                    size: 34.0,
                    color: kColorLight,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  shape: const CircleBorder(),
                  elevation: 0,
                )
              ],
            ),
          ),
          const LogoHeader(),
        ],
      ),
    );
  }
}
