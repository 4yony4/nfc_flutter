import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nfc_flutter/home_views/Product.dart';

import 'home_views/Home.dart';
import 'home_views/Home2.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC Flutter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: const HomePage(title: 'NFC Flutter'),
      routes: {
        '/':(context) => HomePage(title: 'NFC Flutter'),
        '/Product':(context) => Product()
      },
    );
  }
}