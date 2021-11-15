import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';

import 'package:mockoin/services/user_service.dart';
import 'package:mockoin/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  
  const SettingsScreen({ Key? key }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserService userService = UserService();
  Map<dynamic, dynamic> userData = {};

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
          userData.isNotEmpty ? SizedBox(
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
                    Text(userData["name"], style: kHeadingStyleMd),
                    const SizedBox(height: 5,),
                    Text(userData["email"], style: kHeadingStyleSm.copyWith(
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

          isLogged ? ElevatedButton(
            onPressed: () async {
              await userService.logout(context: context).then((value) => fetchUser());
            },
            child: const Text('Logout'),
          ) : ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login').then((value) => fetchUser());
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

// Padding(
//   padding: const EdgeInsets.all(16),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.asset('assets/logoMin.png', height: 40),
//           const SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text('Mockoin', style: TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.w300,
//                 color: kColorBlue
//               ),),
//               Text('Risk free investment', style: TextStyle(
//                 fontSize: 16,
//                 color: kColorGreen
//               ),)
//             ],
//           ),
//         ],
//       ),

//       isLogged ? ElevatedButton(
//         onPressed: () {
//           userService.logout(context: context);
//         },
//         child: const Text('Logout'),
//       ) : ElevatedButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/login');
//         },
//         child: const Text('Login'),
//       ),
//     ],
//   ),
// ),