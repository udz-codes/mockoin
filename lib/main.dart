// Imports: Screens
import 'package:flutter/material.dart';
import 'package:mockoin/mockoin.dart';

// Imports: Screens
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Mockoin(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
