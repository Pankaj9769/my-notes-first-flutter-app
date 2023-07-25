
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotesflutter/constants/routes.dart';
import 'package:mynotesflutter/views/login_view.dart';
import 'package:mynotesflutter/views/notes_view.dart';
import 'package:mynotesflutter/views/register_view.dart';
import 'package:mynotesflutter/views/verify_mail_view.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const HomePage(
        title: '',
      ),
      routes: {
        loginRoute: (context) => const LoginView(
              title: 'LoginPage',
            ),
        registerRoute: (context) => const RegisterView(
              title: 'RegistrationPage',
            ),
        notesRoute: (context) => const NotesView(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            final emailVerified = user?.emailVerified ?? false;
            if (user != null) {
              if (emailVerified) {
                return const NotesView();
              } else {
                return const EmailVerification();
              }
            } else {
              return const LoginView(
                title: 'login',
              );
            }
          default:
            return const RefreshProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout }

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          const Text(
            "Are you Sure you want to Logout?",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Colors.blueAccent,
      );
    },
  ).then(
    (value) => value ?? false,
  );
}
