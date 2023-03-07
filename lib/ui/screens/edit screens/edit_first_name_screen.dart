import 'package:crypto_world/cubit/edit_first_name_cubit.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:crypto_world/utils/custom_error_dialog.dart';
import 'package:crypto_world/utils/custom_success_response_dialog.dart';
import 'package:crypto_world/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditFirstNameScreen extends StatefulWidget {
  const EditFirstNameScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  State<EditFirstNameScreen> createState() => _EditFirstNameScreenState();
}

class _EditFirstNameScreenState extends State<EditFirstNameScreen> {
  final TextEditingController _newFirstName = TextEditingController();
  final TextEditingController _confirmFirstName = TextEditingController();

  void updateUserFirstName() async {
    String firstName = _newFirstName.text;
    String confirmed = _confirmFirstName.text;

    if (firstName.isEmpty) {
      showCustomErrorDialog(context, "Please enter a first name");
    } else if (confirmed.isEmpty) {
      showCustomErrorDialog(context, "Please confirm new first name");
    } else if (firstName != confirmed) {
      showCustomErrorDialog(context, "First names entered do not match");
    } else if (firstName.length > nameCharLimit) {
      showCustomErrorDialog(
          context, "First name cannot exceed $nameCharLimit characters");
    } else if (confirmed.length > nameCharLimit) {
      showCustomErrorDialog(context,
          "Confirmed first name cannot exceed $nameCharLimit characters");
    } else {
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

      firstName = capitalizeFirstLetter(_newFirstName.text);

      BlocProvider.of<EditFirstNameCubit>(context)
          .updateUserFirstName(firstName, widget.userID);

      await Future.delayed(const Duration(seconds: 2));

      // dismisses orange loading indicator
      Navigator.of(context).pop();

      showCustomSuccessResponseDialog(
        context,
        'First name changed successfully',
        () {
          // pop once to dismiss pop up
          Navigator.of(context).pop();
          // pop twice to go back to settings screen
          Navigator.of(context).pop();
        },
      );
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
          "Edit first name",
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
              //         'Current first name: ',
              //         style: TextStyle(
              //           color: kTextColor,
              //           fontSize: 18,
              //         ),
              //       ),
              //       BlocBuilder<UserFirstNameCubit, UserFirstNameState>(
              //         builder: (_, state) {
              //           return Text(
              //             state.userFirstName,
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
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Row(
                  children: [
                    Text(
                      'Enter new first name',
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
                  controller: _newFirstName,
                  hint: "First name",
                  icon: Icons.text_snippet,
                  obscureText: false,
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
                      'Confirm first name',
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
                  controller: _confirmFirstName,
                  hint: "Confirm first name",
                  icon: Icons.text_snippet_outlined,
                  obscureText: false,
                  inputType: TextInputType.text,
                  next: false,
                  focusNode: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: updateUserFirstName,
                  child: const MakeChangeButtonBoxDecoration(),
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
