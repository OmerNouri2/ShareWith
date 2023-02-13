//@dart=2.9
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import 'signup_page.dart';
import 'authentication_service.dart';
import 'feed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp _fbApp = await Firebase.initializeApp();
  // FirebaseApp _fbApp = await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //         apiKey: "AIzaSyAHHzQ5rCJj3EEB_hpUzfieUPaKc5nVwfE",
  //         appId: "1:210089594355:android:79624f7bf36438c0d69686",
  //         messagingSenderId: "210089594355",
  //         projectId: "sharewith-d7de2",
  //         databaseURL: "https://sharewith-d7de2-default-rtdb.firebaseio.com"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ShareWith App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MultiProvider(
          providers: [
            Provider<AuthenticationService>(
              create: (_) => AuthenticationService(FirebaseAuth.instance),
            ),
            StreamProvider(
              create: (context) =>
                  context.read<AuthenticationService>().authStateChanges,
              initialData: null,
            ),
          ],
          child: AuthenticationWrapper(),
        ));
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key key}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String user_email;
  String user_password;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Welcome',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'Email Address',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'Password',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text(
                'Forgot Password',
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(130, 5, 130, 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide(
                        color: Color.fromARGB(221, 0, 0, 0), width: 1),
                    primary: Color.fromARGB(255, 7, 176, 255), //Change
                    fixedSize: Size(80, 40),
                    elevation: 15,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(
                        Icons.login,
                        // size: 19,
                      )
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      user_email = emailController.text.trim();
                      user_password = passwordController.text.trim();
                    });
                    context
                        .read<AuthenticationService>()
                        .signIn(user_email, user_password);
                  },
                )),
            Row(
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StatefulSignupPage()),
                    );
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  static const String _title = 'ShareWith';
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      DatabaseReference database = FirebaseDatabase.instance.ref();
      return Scaffold(
        body: FeedWidget(context.watch<User>().uid, database),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: const HomePageWidget(),
    );
  }
}
