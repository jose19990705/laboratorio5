import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:laboratorio5/pages/splash_page.dart';

import 'models/local_cities.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(LocalCityAdapter());
  await Hive.openBox<LocalCity>('localCityBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Cinzel-VariableFont_wght',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashPage()
    );
  }
}


