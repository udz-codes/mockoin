// Imports: Packages
import 'package:flutter/material.dart';
import 'package:mockoin/mockoin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

// Imports: Screens
import 'package:mockoin/screens/login_screen.dart';
import 'package:mockoin/screens/register_screen.dart';

// Improts: Providers
import 'providers/authentication_provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      child: const MyApp()
    )
  );
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
      // home: Scaffold(body: Center(child: Text(context.read<AuthProvider>().getToken)),),
      initialRoute: '/',
      routes: {
        '/': (context) => Mockoin(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
