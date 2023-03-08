import 'package:crypto_world/cubit/notifications_cubit.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:crypto_world/utils/custom_error_dialog.dart';
import 'package:crypto_world/utils/logos.dart';
import 'package:crypto_world/utils/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateNotificationScreen extends StatefulWidget {
  const CreateNotificationScreen({
    Key? key,
    required this.userID,
    required this.screenID,
    required this.currencyName,
    required this.symbol,
  }) : super(key: key);

  final String userID;
  final String screenID;
  final String currencyName;
  final String symbol;

  @override
  State<CreateNotificationScreen> createState() =>
      _CreateNotificationScreenState();
}

class _CreateNotificationScreenState extends State<CreateNotificationScreen> {
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();
  bool up = true;
  bool down = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(
      () {
        bool hasFocus = focusNode.hasFocus;
        if (hasFocus) {
          KeyboardOverlay.showOverlay(context);
        } else {
          KeyboardOverlay.removeOverlay();
        }
      },
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void createNotification() {
    String criteria = up ? 'up' : 'down';
    String percent = textController.text;
    if (percent.length > 5) {
      showCustomErrorDialog(context, 'Percentage cannot exceed 99.99%');
    } else if (percent.isEmpty) {
      showCustomErrorDialog(context, 'Please enter a percentage!');
    } else if (percent[0] == '-') {
      showCustomErrorDialog(context, 'Cannot enter a negative percent!');
    } else if (percent == '0.00') {
      showCustomErrorDialog(context, 'Cannot enter 0 percent!');
    } else {
      double officialPercent = double.parse(percent);
      officialPercent *= criteria == 'down' ? -1.0 : 1.0;

      BlocProvider.of<NotificationsCubit>(context).addNotificationSetting(
        widget.currencyName,
        widget.symbol,
        criteria,
        officialPercent,
        widget.userID,
        widget.screenID,
      );

      Navigator.of(context).pop();
      // print('criteria: $criteria');
      // print('percent: $percent');
      // print('officialPercent: $officialPercent');
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
          'Create notification',
          style: TextStyle(
            color: kTextColor,
            fontSize: 24,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
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
              AssetLogo(symbol: widget.symbol),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Center(
                  child: Text(
                    'Send a notification when the price of ${widget.currencyName} in the past 24h is ',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Row(
                  children: [
                    Expanded(
                      // Color(0xFF222222)
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (up) {
                              up = false;
                            } else {
                              up = true;
                              down = false;
                            }
                          });
                        },
                        child: CriteriaOption(
                          criteria: 'Up',
                          isPressed: up,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (down) {
                              down = false;
                            } else {
                              down = true;
                              up = false;
                            }
                          });
                        },
                        child: CriteriaOption(
                          criteria: 'Down',
                          isPressed: down,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: PercentFormField(
                  controller: textController,
                  focusNode: focusNode,
                  hint: 'Percent',
                  icon: Icons.percent,
                  obscureText: false,
                  inputType: TextInputType.number,
                  enableNumberFormat: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: GestureDetector(
                  onTap: createNotification,
                  child: const CreateButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateButton extends StatelessWidget {
  const CreateButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: kDarkBlue.withOpacity(0.7),
        borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve + 5)),
      ),
      child: Center(
        child: Text(
          'Create',
          style: TextStyle(
            color: kTextColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class InputDoneView extends StatelessWidget {
  const InputDoneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF222222),
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: CupertinoButton(
            padding: const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Text(
              "Done",
              style: TextStyle(
                color: kTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KeyboardOverlay {
  static OverlayEntry? _overlayEntry;

  static showOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }

    OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            right: 0.0,
            left: 0.0,
            child: const InputDoneView());
      },
    );

    overlayState!.insert(_overlayEntry!);
  }

  static removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}

class CriteriaOption extends StatelessWidget {
  const CriteriaOption({
    Key? key,
    required this.criteria,
    required this.isPressed,
  }) : super(key: key);

  final String criteria;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isPressed ? kDarkBlue.withOpacity(0.7) : Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(kRadiusCurve + 5),
        ),
        border: Border.all(
          color: isPressed ? kDarkBlue.withOpacity(0.7) : kMainBGColor,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          criteria,
          style: TextStyle(
            color: kTextColor,
          ),
        ),
      ),
    );
  }
}

class AssetLogo extends StatelessWidget {
  const AssetLogo({
    Key? key,
    required this.symbol,
  }) : super(key: key);

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kPadding),
      child: logos.containsKey(symbol)
          ? SizedBox(
              height: 120,
              child: Image.asset(
                'assets/images/${logos[symbol]}',
              ),
            )
          : Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: kTextColor,
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.question_mark,
                  color: kTextColor,
                ),
              ),
            ),
    );
  }
}
