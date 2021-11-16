import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'package:mockoin/components/logo_header.dart';
import 'package:mockoin/components/text_input_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mockoin/services/user_service.dart';
import 'package:mockoin/services/snackbar_service.dart';
import 'package:mockoin/components/green_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:mockoin/providers/authentication_provider.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  SnackbarService snackbarService = SnackbarService();
  UserService user = UserService();

  bool _loading = false;

  void handleLogin (context) async {
    
    setState(() {
      _loading = true;
    });

    var response  = await user.login(
      email: emailController.text,
      password: passwordController.text
    );

    setState(() {
      _loading = false;
    });

    if (response.statusCode == 200) {
      snackbarService.successToast(
        context: context,
        text: "Login successful",
      );

      Provider.of<AuthProvider>(context, listen: false).checkToken();
      Navigator.pop(context);

      SharedPreferences _prefs = await SharedPreferences.getInstance();
      print(_prefs.getString('token'));
    } else {
      snackbarService.failureToast(
        context: context,
        text: response.body,
      );
    }
  }

  bool validationCheck(context) {
    if(emailController.text.isEmpty || passwordController.text.isEmpty) {                
      snackbarService.failureToast(
        context: context,
        text: "Please fill all fields",
      );
      return false;
    }
    
    // Email validation
    else if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text) != true){
      snackbarService.failureToast(
        context: context,
        text: "Please enter a valid email address",
      );
      return false;
    }

    else if (passwordController.text.length < 8) {
      snackbarService.failureToast(
        context: context,
        text: "Password must be atleast 8 characters",
      );
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GreenLoader(
      loading: _loading,
      child: Scaffold(
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
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: const TextStyle(color: kColorBlue),
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, '/register')
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  RawMaterialButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if(validationCheck(context)) handleLogin(context);
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
      ),
    );
  }
}
