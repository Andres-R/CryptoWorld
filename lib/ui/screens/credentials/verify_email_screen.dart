import 'dart:async';
import 'package:crypto_world/ui/screens/general/router_screen.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) {
          checkEmailVerified();
        },
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 10));
      setState(() => canResendEmail = true);
    } on FirebaseAuthException catch (e) {
      print(e);

      // show error pop up e.message
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? RouterScreen(userID: widget.userID)
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kMainBGColor,
              centerTitle: true,
              title: Text(
                'Verify Email',
                style: TextStyle(
                  color: kThemeColor,
                ),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                color: kMainBGColor,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kMainBGColor,
                    kMainBGColor,
                    kDarkBlue,
                  ],
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(kPadding / 2),
                    child: Column(
                      children: [
                        Text(
                          'A verification email has been sent to ',
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser!.email!,
                          style: TextStyle(
                            color: kThemeColor,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: kPadding * 2),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      kPadding,
                      kPadding,
                      kPadding,
                      0,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        canResendEmail ? await sendVerificationEmail() : null;
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: kMainBGColor,
                          border: Border.all(
                            color: kThemeColor,
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(kRadiusCurve + 5)),
                        ),
                        child: Center(
                          child: Text(
                            'Resend mail',
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
                    child: GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: kMainBGColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(kRadiusCurve + 5)),
                          border: Border.all(
                            color: kThemeColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
