import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';


import 'Model/person_model.dart';
import 'Model/universe_model.dart';
import 'view/home_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(UniverResponseAdapter());
  Hive.registerAdapter(UniverAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
