import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:events/screens/launch_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LaunchScreen(),
    );
  }
}

Future testData() async {
  /*FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection('event_details').get();
    var details = data.docs.toList();
    details.forEach((d) {
      print("Document ID: ${d.data()..forEach((key, value) {
          print("$key: $value");
        })}");
    });*/
}
