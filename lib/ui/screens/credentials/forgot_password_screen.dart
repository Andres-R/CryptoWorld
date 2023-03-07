import 'package:crypto_world/utils/constants.dart';
import 'package:crypto_world/utils/custom_error_dialog.dart';
import 'package:crypto_world/utils/custom_success_response_dialog.dart';
import 'package:crypto_world/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  void sendEmail() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      showCustomErrorDialog(context, 'Please enter email');
    } else {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return Center(
              child: CircularProgressIndicator(
                color: kThemeColor,
              ),
            );
          },
        );
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        await Future.delayed(const Duration(seconds: 2));

        // dismisses orange loading indicator
        Navigator.of(context).pop();

        showCustomSuccessResponseDialog(
          context,
          'Email to reset password sent',
          () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        );
      } on FirebaseAuthException catch (e) {
        print(e.message);
        // dismisses orange loading indicator
        Navigator.of(context).pop();
        if (e.message ==
            'There is no user record corresponding to this identifier. The user may have been deleted.') {
          showCustomErrorDialog(
              context, 'There is no user record corresponding to this email');
        } else {
          showCustomErrorDialog(context, e.message!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kMainBGColor,
        centerTitle: true,
        title: Text(
          'Reset password',
          style: TextStyle(
            color: kTextColor,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 4),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Text(
                  'Reset your password by receiving an email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: emailController,
                  hint: 'Email',
                  icon: Icons.email_outlined,
                  obscureText: false,
                  inputType: TextInputType.emailAddress,
                  next: false,
                  focusNode: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: sendEmail,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius:
                          BorderRadius.all(Radius.circular(kRadiusCurve + 5)),
                      border: Border.all(
                        color: kThemeColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Reset password',
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
      ),
    );
  }
}
