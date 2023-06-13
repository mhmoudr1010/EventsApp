import 'package:events/shared/auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'event_screen.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    Auth auth = Auth();
    auth.getUser().then((user) {
      MaterialPageRoute route;
      if (user != null) {
        route = MaterialPageRoute(
            builder: (context) => EventScreen(
                  uid: user.uid,
                ));
      } else {
        route = MaterialPageRoute(builder: (context) => const LoginScreen());
      }
      Navigator.pushReplacement(context, route);
    }).catchError((err) => print("this getUser() Future is causing: $err "));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
