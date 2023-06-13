import 'package:events/screens/event_screen.dart';
import 'package:flutter/material.dart';

import '../shared/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  String? _userId;
  String? _password;
  String? _email;
  String? _message;

  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  late Auth _auth;
  @override
  void initState() {
    _auth = Auth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log in')),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              emaiInput(),
              passwordInput(),
              mainButton(),
              secondryButton(),
              validationMessage(),
            ],
          )),
        ),
      ),
    );
  }

  Widget emaiInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: TextFormField(
        controller: txtEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'email',
          icon: Icon(Icons.mail),
        ),
        validator: (text) => text!.isEmpty ? 'Email is required' : '',
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: TextFormField(
          controller: txtPassword,
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          decoration: const InputDecoration(
              hintText: 'password', icon: Icon(Icons.enhanced_encryption)),
          validator: (text) => text!.isEmpty ? 'Password is required' : '',
        ));
  }

  Widget mainButton() {
    String buttonText = _isLogin ? 'Login' : 'Sign up';
    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: ElevatedButton(
        onPressed: submit,
        child: Text(buttonText),
      ),
    );
  }

  Widget secondryButton() {
    String buttonText = !_isLogin ? 'Log in' : 'Sign up';
    return TextButton(
        onPressed: () {
          setState(() {
            _isLogin = !_isLogin;
          });
        },
        child: Text(buttonText));
  }

  Widget validationMessage() {
    return Text(
      (_message == null) ? '' : _message!,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Future submit() async {
    setState(() {
      _message = '';
    });
    try {
      if (_isLogin) {
        _userId = await _auth.login(txtEmail.text, txtPassword.text);
        print("Login for user $_userId");
      } else {
        _userId = await _auth.signUp(txtEmail.text, txtPassword.text);
        print('Sign up for user $_userId');
      }
      if (_userId != null) {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventScreen(
                uid: _userId!,
              ),
            ));
      }
    } catch (e) {
      print("Error while login or sign up: $e");
      setState(() {
        _message = e.toString();
      });
    }
  }
}
