import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.title});

  final String title;

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
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          return Column(
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
                 try{
                   final email = _email.text;
                   final password = _password.text;
                   final userCredential = await FirebaseAuth.instance
                       .signInWithEmailAndPassword(
                     email: email,
                     password: password,
                   );
                   print(userCredential);
                 } on FirebaseAuthException catch (error){
                   if(error.code == 'wrong-password')
                     {
                       print("Invalid Email Id/Password");
                     } else if(error.code == 'invalid-email'){
                     print("Invalid Email Id");
                   }
                   else if(error.code == 'user-not-found'){
                     print("Email Id is not registered  with us");
                   }
                   else{
                     print(error);
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
            ],
          );
        },
      ),
    );
  }
}
