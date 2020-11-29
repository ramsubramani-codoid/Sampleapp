import 'package:flutter/material.dart';
import 'package:sampleapp/screens/offline_user_list.dart';
import 'package:sampleapp/splash_screen.dart';
import 'package:sampleapp/utils/constants.dart';


void main() => runApp(Mainapp());

class Mainapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
          primarySwatch: Colors.lightBlue
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        OFFLINE_USER_LIST_ROUTE: (context) => Offlineuserlist(),
      },
    );
  }
}