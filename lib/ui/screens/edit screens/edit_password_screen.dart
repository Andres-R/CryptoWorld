import 'package:crypto_world/cubit/edit_password_cubit.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:crypto_world/utils/custom_error_dialog.dart';
import 'package:crypto_world/utils/custom_success_response_dialog.dart';
import 'package:crypto_world/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  late FirebaseAuth fbaInstance;

  @override
  void initState() {
    super.initState();
    fbaInstance = FirebaseAuth.instance;
  }

  void updateUserPassword() async {
    String password = _newPasswordController.text;
    String confirmed = _confirmPasswordController.text;
    String oldPassword = _oldPasswordController.text;

    if (password.isEmpty) {
      showCustomErrorDialog(context, "Please enter a new password");
    } else if (confirmed.isEmpty) {
      showCustomErrorDialog(context, "Please confirm new password");
    } else if (oldPassword.isEmpty) {
      showCustomErrorDialog(context, "Please enter existing password");
    } else if (password != confirmed) {
      showCustomErrorDialog(context, "Passwords entered do not match");
    } else if (password.length > passwordLimit) {
      showCustomErrorDialog(
          context, "Password cannot exceed $passwordLimit characters");
    } else if (confirmed.length > passwordLimit) {
      showCustomErrorDialog(context,
          "Confirmed password cannot exceed $passwordLimit characters");
    } else {
      // BlocProvider.of<UserPasswordCubit>(context)
      //     .updateUserPassword(password, widget.userID);

      // Navigator.of(context).pop();
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
        String userEmail = user.email!;
        AuthCredential credentials = EmailAuthProvider.credential(
            email: userEmail, password: oldPassword);
        UserCredential result =
            await user.reauthenticateWithCredential(credentials);

        await result.user!.updatePassword(password);
        BlocProvider.of<EditPasswordCubit>(context)
            .updateUserPassword(password, widget.userID);

        await Future.delayed(const Duration(seconds: 2));
        // dismisses orange loading indicator
        Navigator.of(context).pop();

        showCustomSuccessResponseDialog(
          context,
          'Password changed succesfully',
          () {
            // pop once to dismiss pop up
            Navigator.of(context).pop();
            // pop twice to go back to settings screen
            Navigator.of(context).pop();
          },
        );

        //Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        print(e);
        // dismisses orange loading indicator
        Navigator.of(context).pop();
        if (e.message ==
            'The password is invalid or the user does not have a password.') {
          showCustomErrorDialog(context, 'Incorrect existing password');
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
          "Edit Password",
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Row(
                  children: [
                    Text(
                      'Enter new Password',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _newPasswordController,
                  hint: "Password",
                  icon: Icons.text_snippet,
                  obscureText: true,
                  inputType: TextInputType.text,
                  next: true,
                  focusNode: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Row(
                  children: [
                    Text(
                      'Confirm new password',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _confirmPasswordController,
                  hint: "Confirm password",
                  icon: Icons.text_snippet_outlined,
                  obscureText: true,
                  inputType: TextInputType.text,
                  next: true,
                  focusNode: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Text(
                  'Enter existing password to authorize password change',
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: CustomTextFormField(
                  controller: _oldPasswordController,
                  hint: "Existing password",
                  icon: Icons.text_snippet_outlined,
                  obscureText: true,
                  inputType: TextInputType.text,
                  next: false,
                  focusNode: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: updateUserPassword,
                  child: const MakeChangeButtonBoxDecoration(),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MakeChangeButtonBoxDecoration extends StatelessWidget {
  const MakeChangeButtonBoxDecoration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: kMainBGColor,
        border: Border.all(
          color: kThemeColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve + 5)),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Update password",
          style: TextStyle(
            fontSize: 18,
            color: kTextColor,
          ),
        ),
      ),
    );
  }
}
