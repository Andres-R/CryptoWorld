import 'package:crypto_world/cubit/edit_email_cubit.dart';
import 'package:crypto_world/cubit/edit_first_name_cubit.dart';
import 'package:crypto_world/cubit/edit_last_name_cubit.dart';
import 'package:crypto_world/cubit/edit_password_cubit.dart';
import 'package:crypto_world/main.dart';
import 'package:crypto_world/ui/screens/credentials/delete_account_screen.dart';
import 'package:crypto_world/ui/screens/edit%20screens/edit_email_screen.dart';
import 'package:crypto_world/ui/screens/edit%20screens/edit_first_name_screen.dart';
import 'package:crypto_world/ui/screens/edit%20screens/edit_last_name_screen.dart';
import 'package:crypto_world/ui/screens/edit%20screens/edit_password_screen.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late EditEmailCubit _userEmailCubit;
  late EditPasswordCubit _userPasswordCubit;
  late EditFirstNameCubit _userFirstNameCubit;
  late EditLastNameCubit _userLastNameCubit;
  late FirebaseAuth fbaInstance;

  @override
  void initState() {
    _userEmailCubit = EditEmailCubit(userID: widget.userID);
    _userPasswordCubit = EditPasswordCubit(userID: widget.userID);
    _userFirstNameCubit = EditFirstNameCubit(userID: widget.userID);
    _userLastNameCubit = EditLastNameCubit(userID: widget.userID);
    fbaInstance = FirebaseAuth.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EditEmailCubit>(
          create: (context) => _userEmailCubit,
        ),
        BlocProvider<EditPasswordCubit>(
          create: (context) => _userPasswordCubit,
        ),
        BlocProvider<EditFirstNameCubit>(
          create: (context) => _userFirstNameCubit,
        ),
        BlocProvider<EditLastNameCubit>(
          create: (context) => _userLastNameCubit,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: kMainBGColor,
          automaticallyImplyLeading: false,
          title: Text(
            "Settings",
            style: TextStyle(
              color: kTextColor,
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
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: Container(
                    color: kMainBGColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BlocBuilder<EditFirstNameCubit, EditFirstNameState>(
                              builder: (_, fnameState) {
                                return BlocBuilder<EditLastNameCubit,
                                    EditLastNameState>(
                                  builder: (_, lnameState) {
                                    return areNamesLarge(
                                            fnameState.userFirstname,
                                            lnameState.userLastname)
                                        ? Column(
                                            children: [
                                              Text(
                                                fnameState.userFirstname,
                                                style: TextStyle(
                                                  color: kThemeColor,
                                                  fontSize: 22,
                                                ),
                                              ),
                                              Text(
                                                lnameState.userLastname,
                                                style: TextStyle(
                                                  color: kThemeColor,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Text(
                                                fnameState.userFirstname,
                                                style: TextStyle(
                                                  color: kThemeColor,
                                                  fontSize: 22,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                lnameState.userLastname,
                                                style: TextStyle(
                                                  color: kThemeColor,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ],
                                          );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 5),
                            BlocBuilder<EditEmailCubit, EditEmailState>(
                              builder: (_, state) {
                                return Text(
                                  state.email,
                                  style: TextStyle(
                                    color: kThemeColor,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: kDarkBlue.withOpacity(0.5),
                      borderRadius:
                          BorderRadius.all(Radius.circular(kRadiusCurve)),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: _userEmailCubit,
                                    child: EditEmailScreen(
                                      userID: widget.userID,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: const SettingsOption(
                            title: 'Email',
                            icon: Icons.email,
                          ),
                        ),
                        const SettingsDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: _userFirstNameCubit,
                                    child: EditFirstNameScreen(
                                      userID: widget.userID,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: const SettingsOption(
                            title: 'First name',
                            icon: Icons.person,
                          ),
                        ),
                        const SettingsDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: _userLastNameCubit,
                                    child: EditLastNameScreen(
                                      userID: widget.userID,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: const SettingsOption(
                            title: 'Last name',
                            icon: Icons.person,
                          ),
                        ),
                        const SettingsDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: _userPasswordCubit,
                                    child: EditPasswordScreen(
                                      userID: widget.userID,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: const SettingsOption(
                            title: 'Password',
                            icon: Icons.lock,
                          ),
                        ),
                        const SettingsDivider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return DeleteAccountScreen(
                                    userID: widget.userID,
                                  );
                                },
                              ),
                            );
                          },
                          child: const SettingsOption(
                            title: 'Delete account',
                            icon: Icons.block,
                          ),
                        ),
                        const SettingsDivider(),
                        GestureDetector(
                          onTap: () async {
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
                            await Future.delayed(const Duration(seconds: 2));
                            try {
                              await fbaInstance.signOut();
                            } on FirebaseAuthException catch (e) {
                              print(e);
                            }

                            navigatorKey.currentState!
                                .popUntil((route) => route.isFirst);
                          },
                          child: const SettingsOption(
                            title: 'Sign out',
                            icon: Icons.logout,
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.all(kPadding),
                        //   child: GestureDetector(
                        //     onTap: () async {
                        //       showDialog(
                        //         context: context,
                        //         barrierDismissible: false,
                        //         builder: (_) {
                        //           return Center(
                        //             child: CircularProgressIndicator(
                        //               color: kThemeColor,
                        //             ),
                        //           );
                        //         },
                        //       );
                        //       FirebaseUpload fbUpload = FirebaseUpload();
                        //       await fbUpload.uploadData(123);

                        //       Navigator.pop(context);

                        //       showCustomSuccessDialog(
                        //         context,
                        //         "Data uploaded successfully",
                        //       );
                        //     },
                        //     child: Container(
                        //       height: 50,
                        //       decoration: BoxDecoration(
                        //         color: kDarkBGColor,
                        //         borderRadius: BorderRadius.all(
                        //           Radius.circular(kRadiusCurve),
                        //         ),
                        //       ),
                        //       child: Center(
                        //         child: Text(
                        //           'Upload data',
                        //           style: TextStyle(
                        //             color: kTextColor,
                        //             fontSize: 18,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
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

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: kPadding),
      child: Divider(
        color: Colors.grey.shade800,
        height: 0,
        thickness: 1,
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  const SettingsOption({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: kDarkBGColor,
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: kPadding,
        ),
        child: Row(
          children: [
            Icon(icon, color: kThemeColor),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: kTextColor,
                fontSize: 18,
              ),
            ),
            Expanded(
              child: Container(
                height: 40,
                color: Colors.transparent,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: kTextColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

bool areNamesLarge(String fname, String lname) {
  bool firstNameLong = false;
  bool lastNameLong = false;
  if ((fname.length == nameCharLimit) ||
      ((fname.length + 1) == nameCharLimit) ||
      ((fname.length + 2) == nameCharLimit)) {
    firstNameLong = true;
  }
  if ((lname.length == nameCharLimit) ||
      ((lname.length + 1) == nameCharLimit) ||
      ((lname.length + 2) == nameCharLimit)) {
    lastNameLong = true;
  }

  return firstNameLong || lastNameLong;
}
