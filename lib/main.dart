import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_world/ui/screens/credentials/login_screen.dart';
import 'package:crypto_world/ui/screens/credentials/verify_email_screen.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      navigatorKey: navigatorKey,
      //home: const LoginScreen(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: kThemeColor,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.hasData) {
            String email = FirebaseAuth.instance.currentUser!.email!;
            return FutureBuilder<String>(
              future: getUserID(email),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String userID = snapshot.data!;
                  return VerifyEmailScreen(userID: userID);
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: kThemeColor,
                    ),
                  );
                }
              },
            );

            //FirebaseAuth.instance.signOut();
            //return Scaffold();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }

  Future<String> getUserID(String userEmail) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();

    List<Map<String, dynamic>> list = snapshot.docs.map((doc) {
      return doc.data(); // doc.data() is a Map<String, dynamic>
    }).toList();

    String userID = list[0]['userID'];
    return userID;
  }
}
