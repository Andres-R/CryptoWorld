import 'package:crypto_world/data/repository/data_repository.dart';
import 'package:crypto_world/main.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:crypto_world/utils/custom_error_dialog.dart';
import 'package:crypto_world/utils/custom_success_response_dialog.dart';
import 'package:crypto_world/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  TextEditingController passwordController = TextEditingController();
  late DataRepository dr;
  late FirebaseAuth fbaInstance;
  bool clickedYes = false;

  @override
  void initState() {
    super.initState();
    dr = DataRepository();
    fbaInstance = FirebaseAuth.instance;
  }

  void deleteAccount() async {
    String password = passwordController.text;
    if (password.isEmpty) {
      showCustomErrorDialog(context, 'Please enter password');
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

        User user = fbaInstance.currentUser!;
        String email = user.email!;
        AuthCredential credentials =
            EmailAuthProvider.credential(email: email, password: password);
        UserCredential result =
            await user.reauthenticateWithCredential(credentials);

        // delete from Authentication
        await result.user!.delete();

        // delete from Firestore Database
        await dr.deleteUserNotifications(widget.userID);
        await dr.deleteUserFavoriteItems(widget.userID);
        await dr.deleteUserAccount(widget.userID);

        await fbaInstance.signOut();

        await Future.delayed(const Duration(seconds: 2));
        // dismisses orange loading indicator
        Navigator.of(context).pop();

        showCustomSuccessResponseDialog(
          context,
          'Account deleted',
          () {
            navigatorKey.currentState!.popUntil((route) => route.isFirst);
          },
        );
      } on FirebaseAuthException catch (e) {
        print(e);
        // dismisses orange loading indicator
        Navigator.of(context).pop();
        if (e.message ==
            'The password is invalid or the user does not have a password.') {
          showCustomErrorDialog(context, 'Incorrect password');
        } else if (e.message ==
            'Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.') {
          showCustomErrorDialog(
              context, 'Access disabled. Reset password or try later');
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
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Delete Account",
          style: TextStyle(
            color: kThemeColor,
            fontSize: 22,
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
          physics: const ClampingScrollPhysics(),
          child: !clickedYes
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: Text(
                        'Are you sure you want to delete your account?',
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            clickedYes = !clickedYes;
                          });
                        },
                        child: const ButtonContainer(text: 'Yes'),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: Text(
                        'Enter password to delete account',
                        style: TextStyle(
                          fontSize: 18,
                          color: kTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: CustomTextFormField(
                        controller: passwordController,
                        hint: "Password",
                        icon: Icons.lock,
                        obscureText: true,
                        inputType: TextInputType.text,
                        next: false,
                        focusNode: null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: GestureDetector(
                        onTap: deleteAccount,
                        child: const ButtonContainer(
                          text: 'Confirm',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: Text(
                        'If you forgot your password, sign out and click the \'Forgot Password\' button presented in the login screen',
                        style: TextStyle(
                          color: kAccentColor,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: kMainBGColor,
        borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve)),
        border: Border.all(
          color: kThemeColor,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: kTextColor,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
