import 'package:crypto_world/utils/constants.dart';
import 'package:crypto_world/utils/logos.dart';
import 'package:flutter/material.dart';

class FavoriteItemCard extends StatelessWidget {
  const FavoriteItemCard({
    Key? key,
    required this.name,
    required this.symbol,
  }) : super(key: key);

  final String name;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kPadding / 2,
        vertical: kPadding,
      ),
      child: Container(
        height: 151,
        width: 151,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(kRadiusCurve)),
          color: kDarkBlue.withOpacity(0.5),
        ),
        child: Padding(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logos.containsKey(symbol)
                  ? SizedBox(
                      height: 60,
                      child: Image.asset(
                        'assets/images/${logos[symbol]}',
                      ),
                    )
                  : Container(
                      height: 60,
                      width: 60,
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
              const Spacer(),
              Text(
                name,
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                symbol,
                style: TextStyle(
                  color: kAccentColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
