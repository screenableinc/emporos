import 'package:emporos/pages/add_item.dart';
import 'package:emporos/pages/orders.dart';
import 'package:emporos/pages/shop_items_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'pages/main_page.dart';
import 'mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up.dart';
void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {




    return MaterialApp(
      title: 'Vendnbuy',
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
        primarySwatch: Colors.pink,
        // platform: TargetPlatform.iOS,
      ),
      home: ProductForm(),

    );
  }
}


