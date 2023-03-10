import 'package:crypto_world/main.dart';
import 'package:crypto_world/ui/screens/credentials/forgot_password_screen.dart';
import 'package:crypto_world/ui/screens/credentials/signup_screen.dart';
import 'package:crypto_world/ui/screens/general/router_screen.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:crypto_world/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void signIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty) {
    } else if (password.isEmpty) {}

    final isValid = formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      // show pop up dialog that email is taken e.message
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  void loginAsGuest() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => RouterScreen(userID: kGuestID),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: kMainBGColor,
      //   centerTitle: true,
      // ),
      body: Container(
        decoration: BoxDecoration(
          color: kMainBGColor,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kDarkBlue,
              kMainBGColor,
              kMainBGColor,
              kDarkBlue,
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height / 8,
                ),
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/logos/Crypto World Logo 1000.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    kPadding,
                    kPadding,
                    kPadding,
                    0,
                  ),
                  child: CustomTextFormField(
                    controller: emailController,
                    hint: 'Email',
                    icon: Icons.email_outlined,
                    obscureText: false,
                    inputType: TextInputType.emailAddress,
                    next: true,
                    focusNode: null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: CustomTextFormField(
                    controller: passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    inputType: TextInputType.text,
                    next: false,
                    focusNode: null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: kThemeColor,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return const ForgotPasswordScreen();
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(width: kPadding / 2),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.all(Radius.circular(kRadiusCurve + 5)),
                        border: Border.all(
                          color: kThemeColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: kTextColor,
                        ),
                      ),
                      SizedBox(width: kPadding),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return SignUpScreen();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            color: kThemeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: GestureDetector(
                    onTap: loginAsGuest,
                    child: Text(
                      'Continue as guest',
                      style: TextStyle(color: kTextColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
