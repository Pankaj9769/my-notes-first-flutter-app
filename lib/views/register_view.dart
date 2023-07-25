import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import '../constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key, required this.title});

  final String? title;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'),),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(
              hintText: 'Email Id',
            ),
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              final userCredential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                email: email,
                password: password,
              );
              devtools.log(userCredential.toString());
            },
            style: const ButtonStyle(
              backgroundColor:
              MaterialStatePropertyAll(Colors.blueAccent),
              shape: MaterialStatePropertyAll(
                BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
              ),
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                    (route) => false,
              );
            },
            child: const Text('Already have an account? Sign In'),
          ),
        ],
      ),
      
    );
      
  }
}
