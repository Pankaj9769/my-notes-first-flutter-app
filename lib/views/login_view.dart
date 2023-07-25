import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotesflutter/constants/routes.dart';

import '../main.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.title});

  final String? title;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(
        title: const Text('Login'),
      ),
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
              try {
                final email = _email.text;
                final password = _password.text;
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                devtools.log(userCredential.toString());
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (error) {
                if (error.code == 'wrong-password') {
                  await showErrorDialog(context, "Invalid Email/Password");
                  //devtools.log("Invalid Email Id/Password");
                } else if (error.code == 'invalid-email') {
                  await showErrorDialog(context, "Invalid Email/Password");
                  //devtools.log("Invalid Email Id");
                } else if (error.code == 'user-not-found') {
                  await showErrorDialog(context, "Email Id is not Registered.");
                  //devtools.log("Email Id is not registered  with us");
                } else {
                  await showErrorDialog(context, "Error: ${error.toString()}");
                  //devtools.log(error.toString());
                }
              }
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
              shape: MaterialStatePropertyAll(
                BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
              ),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not Registered yet? Register Now'),
          ),
        ],
      ),
    );
  }
}
