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

class RegisterScreen extends StatefulWidget {

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  SnackbarService snackbarService = SnackbarService();
  UserService user = UserService();

  bool _loading = false;

  void handleRegistration (context) async {
    
    setState(() {
      _loading = true;
    });

    var response  = await user.register(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text
    );

    setState(() {
      _loading = false;
    });

    if (response.statusCode == 200) {
      snackbarService.successToast(
        context: context,
        text: "Registration successful",
      );

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
    // bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text);

    // No fields must be empty
    if(
      emailController.text.isEmpty
      || passwordController.text.isEmpty
      || nameController.text.isEmpty
      || confirmPassController.text.isEmpty
    ) {                
      snackbarService.failureToast(
        context: context,
        text: "Please fill all fields",
      );
      return false;
    }

    // Name must eb atleast 3 characters
    else if (nameController.text.length < 3) {
      snackbarService.failureToast(
        context: context,
        text: "Name must be atleast 3 characters",
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
    
    // Password must be atleast 8 characters
    else if (passwordController.text.length < 8) {
      snackbarService.failureToast(
        context: context,
        text: "Password must be atleast 8 characters",
      );
      return false;
    }
    
    // Password and Confirmation password must be same
    else if (
      passwordController.text.length >= 8
      && confirmPassController.text != passwordController.text
    ) {
      snackbarService.failureToast(
        context: context,
        text: "Password and Confirmation Password must be same",
      );
      return false;
    }

    return true;
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
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  const Text(
                    'Register',
                    style: kHeadingStyle,
                  ),
                  const SizedBox(height: 30,),
                  TextInputBar(
                    placeholder: 'Full Name',
                    controller: nameController
                  ),
                  const SizedBox(height: 10,),
                  TextInputBar(
                    placeholder: 'Email',
                    controller: emailController
                  ),
                  const SizedBox(height: 10,),
                  TextInputBar(
                    placeholder: 'Password',
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 10,),
                  TextInputBar(
                    placeholder: 'Confirm Password',
                    controller: confirmPassController,
                    obscureText: true,
                    inputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 10,),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(color: kColorBlue),
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushReplacementNamed(context, '/login')
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  RawMaterialButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if(validationCheck(context)) handleRegistration(context);
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
