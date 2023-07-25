import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotesflutter/main.dart';
import 'dart:developer' as devtools show log;

import '../constants/routes.dart';
import '../utilities/show_error_dialog.dart';

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
      appBar: AppBar(
        title: const Text('Register'),
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
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute,(route) => false,);
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (error) {
                switch (error.code) {
                  case 'weak-password':
                    await showErrorDialog(
                      context,
                      'Enter a Strong Password',
                    );
                    break;
                  case 'invalid-email':
                    await showErrorDialog(
                      context,
                      'Enter Valid Email Id',
                    );
                    break;
                  case 'email-already-in-use':
                    await showErrorDialog(
                      context,
                      'Email is already Registered',
                    );
                  default:
                    await showErrorDialog(
                      context,
                      error.code.toString(),
                    );

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
