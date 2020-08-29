import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:wanderapp/src/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark
    ));

    return MaterialApp(
      title: 'Wander App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
