import 'package:crypto_world/cubit/favorite_items_cubit.dart';
import 'package:crypto_world/data/models/crypto_currency_model.dart';
import 'package:crypto_world/data/repository/data_repository.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:crypto_world/utils/logos.dart';

class CryptoCurrencyCard extends StatefulWidget {
  const CryptoCurrencyCard({
    Key? key,
    required this.cryptoCurrency,
    required this.isFavorited,
    required this.userID,
  }) : super(key: key);

  final CryptoCurrency cryptoCurrency;
  final bool isFavorited;
  final String userID;

  @override
  State<CryptoCurrencyCard> createState() => _CryptoCurrencyCardState();
}

class _CryptoCurrencyCardState extends State<CryptoCurrencyCard> {
  DataRepository dr = DataRepository();
  late bool isFavorited;
  bool hasBeenPressed = false;
  double cardHeight = 80;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.isFavorited;
  }

  Color determineColor(double percentage) {
    if (percentage > 0) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  IconData determineIcon(double percentage) {
    if (percentage > 0) {
      return Icons.call_made_rounded;
    } else {
      return Icons.call_received_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kPadding,
        vertical: kPadding / 2,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            hasBeenPressed = !hasBeenPressed;
            cardHeight = hasBeenPressed ? 200 : 80;
          });
        },
        child: Container(
          height: cardHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(kRadiusCurve),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kMainBGColor,
                kDarkBlue,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        logos.containsKey(widget.cryptoCurrency.symbol)
                            ? SizedBox(
                                height: 30,
                                child: Image.asset(
                                  'assets/images/${logos[widget.cryptoCurrency.symbol]}',
                                ),
                              )
                            : Container(
                                height: 30,
                                width: 30,
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
                        SizedBox(width: kPadding / 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cryptoCurrency.name,
                              style: TextStyle(
                                color: kTextColor,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.cryptoCurrency.symbol,
                              style: TextStyle(
                                color: kAccentColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${numberFormat.format(widget.cryptoCurrency.price)}',
                              style: TextStyle(
                                color: kTextColor,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${widget.cryptoCurrency.percentChange24Hour.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: determineColor(
                                      widget.cryptoCurrency.percentChange24Hour,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  determineIcon(
                                    widget.cryptoCurrency.percentChange24Hour,
                                  ),
                                  color: determineColor(
                                    widget.cryptoCurrency.percentChange24Hour,
                                  ),
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () async {
                            bool isInList = await dr.checkForFavoriteItem(
                              widget.cryptoCurrency,
                              widget.userID,
                            );
                            setState(() {
                              if (isInList) {
                                isFavorited = false;
                                BlocProvider.of<FavoriteItemsCubit>(context)
                                    .removeFavoriteItem(
                                  widget.cryptoCurrency,
                                  widget.userID,
                                );
                              } else {
                                isFavorited = true;
                                BlocProvider.of<FavoriteItemsCubit>(context)
                                    .addFavoriteItem(
                                  widget.cryptoCurrency,
                                  widget.userID,
                                );
                              }
                            });
                          },
                          child: Container(
                            height: 22,
                            width: 22,
                            color: Colors.transparent,
                            child: Center(
                              child: Icon(
                                isFavorited ? Icons.star : Icons.star_outline,
                                color: Colors.yellow,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //const SizedBox(height: 16),

                //const SizedBox(height: 16),
                hasBeenPressed
                    ? Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: kPadding,
                            ),
                            child: Divider(
                              color: kAccentColor.withOpacity(0.5),
                              thickness: 1,
                              height: 0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Past hour',
                                    style: TextStyle(
                                      color: kTextColor,
                                    ),
                                  ),
                                  Text(
                                    '${widget.cryptoCurrency.percentChange1Hour.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: determineColor(
                                        widget
                                            .cryptoCurrency.percentChange1Hour,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Today',
                                    style: TextStyle(color: kTextColor),
                                  ),
                                  Text(
                                    '${widget.cryptoCurrency.percentChange24Hour.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: determineColor(widget
                                          .cryptoCurrency.percentChange24Hour),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'This week',
                                    style: TextStyle(color: kTextColor),
                                  ),
                                  Text(
                                    '${widget.cryptoCurrency.percentChange7Day.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: determineColor(widget
                                          .cryptoCurrency.percentChange7Day),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: kPadding),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '30 days',
                                    style: TextStyle(color: kTextColor),
                                  ),
                                  Text(
                                    '${widget.cryptoCurrency.percentChange30Day.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: determineColor(widget
                                          .cryptoCurrency.percentChange30Day),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '60 days',
                                    style: TextStyle(color: kTextColor),
                                  ),
                                  Text(
                                    '${widget.cryptoCurrency.percentChange60Day.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: determineColor(widget
                                          .cryptoCurrency.percentChange60Day),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '90 days',
                                    style: TextStyle(color: kTextColor),
                                  ),
                                  Text(
                                    '${widget.cryptoCurrency.percentChange90Day.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: determineColor(widget
                                          .cryptoCurrency.percentChange90Day),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
