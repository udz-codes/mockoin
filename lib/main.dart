// Imports: Screens
import 'package:flutter/material.dart';
import 'package:mockoin/mockoin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Imports: Screens
import 'screens/login_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
