import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mockoin/constants.dart';
import 'package:line_icons/line_icons.dart';

// Imports: Screens
import 'package:mockoin/screens/settings_screen.dart';
import 'package:mockoin/screens/prices_screen.dart';

class Mockoin extends StatefulWidget {
  const Mockoin({
    Key? key,
  }) : super(key: key);

  @override
  State<Mockoin> createState() => _MockoinState();
}

class _MockoinState extends State<Mockoin> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorLight,
      body: SafeArea(
        child: const <Widget>[
          PricesScreen(),
          Text('Portfolio'),
          SettingsScreen(),
        ].elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: kColorLight,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
            child: GNav(
              gap: 10,
              iconSize: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              duration: const Duration(milliseconds: 400),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: kColorLight,
              ),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              rippleColor: kColorGreenLight,
              hoverColor: kColorGreenLight,
              color: kColorGreen,
              activeColor: kColorLight,
              tabBackgroundColor: kColorGreen,
              tabs: const [
                GButton(icon: LineIcons.barChartAlt, text: 'Prices'),
                GButton(icon: LineIcons.wallet, text: 'Portfolio'),
                GButton(icon: LineIcons.cog, text: 'Settings'),
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
