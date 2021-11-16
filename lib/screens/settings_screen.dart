import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';

import 'package:mockoin/services/user_service.dart';
import 'package:mockoin/providers/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';

// Components
import 'package:mockoin/components/funds_card.dart';
import 'package:mockoin/components/touchable_tile.dart';


class SettingsScreen extends StatefulWidget {
  
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
  UserService userService = UserService();
  
  Map<dynamic, dynamic> userData = {
    "name": "...",
    "email": "...",
    "funds": "0.0"
  };

  void fetchUser() async {
    Map<dynamic, dynamic> _userData = await userService.fetchUser();
    setState(() {
      userData = _userData;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => fetchUser());
  }
  
  @override
  Widget build(BuildContext context) {
    bool isLogged = context.watch<AuthProvider>().isLogged;
    // print(userData);

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          isLogged ? SizedBox(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userData["name"].toString(), style: kHeadingStyleMd),
                    const SizedBox(height: 5,),
                    Text(userData["email"].toString(), style: kHeadingStyleSm.copyWith(
                      color: Colors.grey
                    )),
                  ],
                ),
              ),
            ),
          ) : SizedBox(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text('Account', style: kHeadingStyleMd),
              ),
            ),
          ),

          if(isLogged) FundsCard(amount: userData["funds"].toString()),
          
          isLogged? TouchableTile(
            textPrimary: "Logout",
            icon: Icons.logout,
            onClick: ()  async{
              await userService.logout(context: context).then((value) => fetchUser());
            },
          ) : TouchableTile(
            textPrimary: "Sign up or Login",
            textSecondary: "Create an account or login",
            icon: LineIcons.user,
            onClick: ()  async{
              await Navigator.pushNamed(context, '/login').then((value) => fetchUser());
            },
          )
        ],
      ),
    );
  }
}