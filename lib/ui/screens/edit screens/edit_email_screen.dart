import 'package:crypto_world/cubit/edit_email_cubit.dart';
import 'package:crypto_world/data/repository/data_repository.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:crypto_world/utils/custom_error_dialog.dart';
import 'package:crypto_world/utils/custom_success_response_dialog.dart';
import 'package:crypto_world/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditEmailScreen extends StatefulWidget {
  const EditEmailScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  State<EditEmailScreen> createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  final TextEditingController _newEmail = TextEditingController();
  final TextEditingController _confirmEmail = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late FirebaseAuth fbaInstance;
  DataRepository dr = DataRepository();

  @override
  void initState() {
    super.initState();
    fbaInstance = FirebaseAuth.instance;
  }

  void updateUserEmail() async {
    String email = _newEmail.text;
    String confirmed = _confirmEmail.text;
    String password = _passwordController.text;

    if (email.isEmpty) {
      showCustomErrorDialog(context, "Please enter a new Email");
    } else if (confirmed.isEmpty) {
      showCustomErrorDialog(context, "Please confirm new Email");
    } else if (password.isEmpty) {
      showCustomErrorDialog(context, "Please enter password");
    } else if (!validateEmail(email)) {
      showCustomErrorDialog(context, "Email entered is not valid");
    } else if (!validateEmail(confirmed)) {
      showCustomErrorDialog(context, "Email confirmed is not valid");
    } else if (email != confirmed) {
      showCustomErrorDialog(context, "Emails entered do not match");
    } else {
      // bool isEmailTaken = await dbController.isEmailTaken(email);

      // if (!isEmailTaken) {
      //   BlocProvider.of<UserEmailCubit>(context)
      //       .updateUserEmail(email, widget.userID);
      //   Navigator.of(context).pop();
      // } else {
      //   showCustomErrorDialog(context, "Email entered is already taken");
      // }

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
        AuthCredential credentials =
            EmailAuthProvider.credential(email: userEmail, password: password);
        UserCredential result =
            await user.reauthenticateWithCredential(credentials);

        await result.user!.updateEmail(email);
        BlocProvider.of<EditEmailCubit>(context)
            .updateUserEmail(email, widget.userID);

        await Future.delayed(const Duration(seconds: 2));

        // dismisses orange loading indicator
        Navigator.of(context).pop();

        showCustomSuccessResponseDialog(
          context,
          'Email changed succesfully',
          () {
            // pop once to dismiss pop up
            Navigator.of(context).pop();
            // pop twice to go back to settings screen
            Navigator.of(context).pop();
          },
        );
      } on FirebaseAuthException catch (e) {
        print(e);
        // dismisses orange loading indicator
        Navigator.of(context).pop();
        if (e.message ==
            'The password is invalid or the user does not have a password.') {
          showCustomErrorDialog(
              context, 'Password entered is invalid for this account.');
        } else if (e.message ==
            'Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.') {
          showCustomErrorDialog(
              context, 'Access disabled. Reset password or try later');
        } else {
          showCustomErrorDialog(context, e.message!);
        }
      }

      // bool isEmailTaken = await dbController.isEmailTaken(email);

      // if (!isEmailTaken) {

      // } else {
      //   if (!mounted) {
      //     return;
      //   }
      //   showCustomErrorDialog(context, "Email entered is already taken");
      // }
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
          "Edit Email",
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
              // Padding(
              //   padding: EdgeInsets.all(kPadding),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Text(
              //         'Current Email: ',
              //         style: TextStyle(
              //           color: kTextColor,
              //           fontSize: 18,
              //         ),
              //       ),
              //       BlocBuilder<UserEmailCubit, UserEmailState>(
              //         builder: (_, state) {
              //           return Text(
              //             state.userEmail,
              //             style: TextStyle(
              //               color: kCurrencyColor,
              //               fontSize: 18,
              //             ),
              //           );
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: kPadding * 2),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Row(
                  children: [
                    Text(
                      'Enter new email',
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
                  controller: _newEmail,
                  hint: "Email",
                  icon: Icons.email,
                  obscureText: false,
                  inputType: TextInputType.emailAddress,
                  next: true,
                  focusNode: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Row(
                  children: [
                    Text(
                      'Confirm new email',
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
                  controller: _confirmEmail,
                  hint: "Confirm email",
                  icon: Icons.mail_outline,
                  obscureText: false,
                  inputType: TextInputType.emailAddress,
                  next: true,
                  focusNode: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Row(
                  children: [
                    Text(
                      'Enter password to confirm email change',
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
                  controller: _passwordController,
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
                  onTap: updateUserEmail,
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
      height: 50,
      decoration: BoxDecoration(
        color: kMainBGColor,
        border: Border.all(
          color: kThemeColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve)),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Make change",
          style: TextStyle(
            fontSize: 18,
            color: kTextColor,
          ),
        ),
      ),
    );
  }
}
