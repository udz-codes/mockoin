import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mockoin/constants.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockoin/services/user_service.dart';

class Mockoin extends StatefulWidget {
  const Mockoin({
    Key? key,
  }) : super(key: key);

  @override
  State<Mockoin> createState() => _MockoinState();
}

class _MockoinState extends State<Mockoin> {
  int _selectedIndex = 0;
  String _token = '';
  UserService userService = UserService();

  void loginCheck() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    setState(() {
      if(_prefs.getString('token') != null) {
        _token = _prefs.getString('token')!;
      } else {
        _token = '';
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => loginCheck());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorLight,
      body: SafeArea(
          // child: _widgetOptions.elementAt(_selectedIndex),
          child: <Widget>[
        Text('Home'),
        Text('Prices'),
        Text('Portfolio'),
        Center(
          child: _token.isEmpty ? ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login').then((value) => loginCheck());
            },
            child: const Text('Login'),
          ) : ElevatedButton(
            onPressed: () {
              userService.logout(callback: loginCheck);
            },
            child: const Text('Logout'),
          ),
        ),
      ].elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: kColorLight,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
            child: GNav(
              gap: 6,
              iconSize: 26,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              duration: const Duration(milliseconds: 400),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: kColorLight,
              ),
              rippleColor: kColorGreenLight,
              hoverColor: kColorGreenLight,
              color: kColorGreen,
              activeColor: kColorLight,
              tabBackgroundColor: kColorGreen,
              tabs: const [
                GButton(icon: LineIcons.home, text: 'Home'),
                GButton(icon: LineIcons.barChartAlt, text: 'Prices'),
                GButton(icon: LineIcons.wallet, text: 'Portfolio'),
                GButton(icon: LineIcons.userAlt, text: 'Account'),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
