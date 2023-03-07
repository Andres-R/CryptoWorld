import 'package:crypto_world/utils/constants.dart';
import 'package:flutter/material.dart';

void showCustomSuccessResponseDialog(
    BuildContext context, String message, VoidCallback onPressed) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomSuccessResponseDialog(
        title: message,
        onPressed: onPressed,
      );
    },
  );
}

class CustomSuccessResponseDialog extends StatelessWidget {
  const CustomSuccessResponseDialog({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve)),
        side: BorderSide(
          color: kThemeColor,
        ),
      ),
      backgroundColor: kMainBGColor,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: 275,
            child: Padding(
              padding: EdgeInsets.all(kPadding),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    "Success!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      color: kTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: onPressed,
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kCurrencyColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(kRadiusCurve),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Okay",
                          style: TextStyle(
                            color: kTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            child: CircleAvatar(
              backgroundColor: kCurrencyColor,
              radius: 40,
              child: CircleAvatar(
                backgroundColor: kMainBGColor,
                radius: 30,
                child: Center(
                  child: Icon(
                    Icons.check,
                    size: 50,
                    color: kTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
