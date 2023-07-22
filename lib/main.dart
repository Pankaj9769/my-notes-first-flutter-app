import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotesflutter/views/login_view.dart';
import 'package:mynotesflutter/views/register_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
     MaterialApp(
      home: const HomePage(
        title: '',
      ),
      routes: {
        '/login/': (context) => const LoginView(
              title: 'LoginPage',
            ),
        '/register/': (context) => const RegisterView(
              title: 'RegistrationPage',
            ),
      },
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
          // final user = FirebaseAuth.instance.currentUser;
          // final emailVerified = user?.emailVerified ?? false;
          // if (emailVerified) {}
          // else {
          //  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const EmailVerification(),),);
          // }
            return const LoginView(
              title: 'login',
            );
          default:
            return const RefreshProgressIndicator();
        }
      },
    );
  }
}

