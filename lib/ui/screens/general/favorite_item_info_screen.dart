import 'package:crypto_world/cubit/favorite_item_info_screen_cubit.dart';
import 'package:crypto_world/cubit/favorite_items_cubit.dart';
import 'package:crypto_world/cubit/notifications_cubit.dart';
import 'package:crypto_world/data/models/crypto_currency_model.dart';
import 'package:crypto_world/data/repository/data_repository.dart';
import 'package:crypto_world/ui/cards/notification_setting_card.dart';
import 'package:crypto_world/ui/screens/notifications/create_notification_screen.dart';
import 'package:crypto_world/ui/screens/notifications/delete_notification_screen.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:crypto_world/utils/custom_error_dialog.dart';
import 'package:crypto_world/utils/logos.dart';
import 'package:crypto_world/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FavoriteItemInfoScreen extends StatefulWidget {
  const FavoriteItemInfoScreen({
    Key? key,
    required this.name,
    required this.symbol,
    required this.isFavorited,
    required this.userID,
    required this.screenID,
  }) : super(key: key);

  final String name;
  final String symbol;
  final bool isFavorited;
  final String userID;
  final String screenID;

  @override
  State<FavoriteItemInfoScreen> createState() => _FavoriteItemInfoScreenState();
}

class _FavoriteItemInfoScreenState extends State<FavoriteItemInfoScreen> {
  DataRepository db = DataRepository();
  late bool isFavorited;
  late FavoriteItemInfoScreenCubit _infoCubit;
  late NotificationsCubit _notificationCubit;
  double kFont = 17;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.isFavorited;
    _infoCubit = FavoriteItemInfoScreenCubit(symbol: widget.symbol);
    _notificationCubit = NotificationsCubit(
      userID: widget.userID,
      screenID: widget.screenID,
    );
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteItemInfoScreenCubit>(
          create: (context) => _infoCubit,
        ),
        BlocProvider<NotificationsCubit>(
          create: (context) => _notificationCubit,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kMainBGColor,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: AppBarTitle(name: widget.name, symbol: widget.symbol),
          actions: [
            GestureDetector(
              onTap: () async {
                bool isInList = await db.checkForFavoriteItemSymbol(
                  widget.symbol,
                  widget.userID,
                );
                setState(() {
                  if (isInList) {
                    isFavorited = false;
                    BlocProvider.of<FavoriteItemsCubit>(context)
                        .removeFavoriteItemSymbol(
                      widget.symbol,
                      widget.userID,
                    );
                    //BlocProvider.of<AssetCubit>(context).rebuild();
                  } else {
                    isFavorited = true;
                    BlocProvider.of<FavoriteItemsCubit>(context)
                        .addFavoriteItemSymbol(
                      widget.name,
                      widget.symbol,
                      widget.userID,
                    );
                    //BlocProvider.of<AssetCubit>(context).rebuild();
                  }
                });
              },
              child: Padding(
                padding: EdgeInsets.only(right: kPadding),
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
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
          child: BlocBuilder<FavoriteItemInfoScreenCubit,
              FavoriteItemInfoScreenState>(
            builder: (_, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: kPadding),
                    AssetLogo(symbol: widget.symbol),
                    SizedBox(height: kPadding * 2),
                    CryptoCurrencyPrice(cryptoCurrency: state.cryptoCurrency),
                    SizedBox(height: kPadding * 2),
                    // const Padding(
                    //   padding: EdgeInsets.all(16.0),
                    //   child: Divider(
                    //     color: Colors.white,
                    //     height: 16,
                    //   ),
                    // ),

                    Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(kRadiusCurve),
                          ),
                          color: kDarkBlue.withOpacity(0.5),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(kPadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Marketcap',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                  Text(
                                    trimDollars(
                                        '\$${numberFormat.format(state.cryptoCurrency.marketCap)}'),
                                    style: TextStyle(
                                      color: kCurrencyColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(kPadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Diluted marketcap',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                  Text(
                                    trimDollars(
                                        '\$${numberFormat.format(state.cryptoCurrency.fullyDilutedMarketCap)}'),
                                    style: TextStyle(
                                      color: kCurrencyColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(kPadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Marketcap rank',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                  Text(
                                    '${state.cryptoCurrency.cmcRank}',
                                    style: TextStyle(
                                      color: kCurrencyColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(kPadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Marketcap dominance',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                  Text(
                                    '${state.cryptoCurrency.marketCapDominance}%',
                                    style: TextStyle(
                                      color: kCurrencyColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.all(16.0),
                    //   child: Divider(
                    //     color: Colors.white,
                    //     //height: 16,
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(kRadiusCurve),
                          ),
                          color: kDarkBlue.withOpacity(0.5),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(kPadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Max supply',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                  Text(
                                    state.cryptoCurrency.maxSupply == null
                                        ? 'Infinite'
                                        : numberFormat
                                            .format(
                                                state.cryptoCurrency.maxSupply)
                                            .toString(),
                                    style: TextStyle(
                                      color: kCurrencyColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(kPadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Circulating',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                  Text(
                                    numberFormat
                                        .format(state
                                            .cryptoCurrency.circulatingSupply)
                                        .toString(),
                                    style: TextStyle(
                                      color: kCurrencyColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(kPadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total supply',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                  Text(
                                    numberFormat
                                        .format(
                                            state.cryptoCurrency.totalSupply)
                                        .toString(),
                                    style: TextStyle(
                                      color: kCurrencyColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.all(16.0),
                    //   child: Divider(
                    //     color: Colors.white,
                    //     //height: 16,
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(kRadiusCurve),
                          ),
                          color: kDarkBlue.withOpacity(0.5),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(kPadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Volume',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                  Text(
                                    '\$${numberFormat.format(state.cryptoCurrency.volume24h)}',
                                    style: TextStyle(
                                      color: kCurrencyColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(kPadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Volume change 24h',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: kFont,
                                    ),
                                  ),
                                  Text(
                                    '${state.cryptoCurrency.percentVolumeChange24h}%',
                                    style: TextStyle(
                                      color: determineColor(state.cryptoCurrency
                                          .percentVolumeChange24h),
                                      fontSize: kFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kDarkBlue.withOpacity(0.5),
                          borderRadius:
                              BorderRadius.all(Radius.circular(kRadiusCurve)),
                        ),
                        child: Column(
                          children: [
                            PriceCategory(
                              category: '1 hour',
                              percent: state.cryptoCurrency.percentChange1Hour,
                            ),
                            PriceCategory(
                              category: '1 day',
                              percent: state.cryptoCurrency.percentChange24Hour,
                            ),
                            PriceCategory(
                              category: '7 days',
                              percent: state.cryptoCurrency.percentChange7Day,
                            ),
                            PriceCategory(
                              category: '30 days',
                              percent: state.cryptoCurrency.percentChange30Day,
                            ),
                            PriceCategory(
                              category: '60 days',
                              percent: state.cryptoCurrency.percentChange60Day,
                            ),
                            PriceCategory(
                              category: '90 days',
                              percent: state.cryptoCurrency.percentChange90Day,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: Divider(
                        color: kTextColor,
                        //height: 16,
                      ),
                    ),
                    BlocBuilder<NotificationsCubit, NotificationsState>(
                      builder: (_, state) {
                        return Padding(
                          padding: EdgeInsets.all(kPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Notifications',
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 22,
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (state.notifications.isEmpty) {
                                        showCustomErrorDialog(context,
                                            'There are no notification settings to delete!');
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) {
                                              return BlocProvider.value(
                                                value: _notificationCubit,
                                                child: DeleteNotificationScreen(
                                                  userID: widget.userID,
                                                  screenID: widget.screenID,
                                                  name: widget.name,
                                                  symbol: widget.symbol,
                                                  settings: state.notifications,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kDarkBlue.withOpacity(0.5),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(kRadiusCurve),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: kPadding,
                                          vertical: kPadding / 2,
                                        ),
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: kTextColor,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: kPadding),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return BlocProvider.value(
                                              value: _notificationCubit,
                                              child: CreateNotificationScreen(
                                                userID: widget.userID,
                                                screenID: widget.screenID,
                                                currencyName: widget.name,
                                                symbol: widget.symbol,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kDarkBlue.withOpacity(0.5),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(kRadiusCurve),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: kPadding,
                                          vertical: kPadding / 2,
                                        ),
                                        child: Text(
                                          'Add',
                                          style: TextStyle(
                                            color: kTextColor,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    BlocBuilder<NotificationsCubit, NotificationsState>(
                      builder: (_, state) {
                        return Column(
                          children: [
                            ...List.generate(
                              state.notifications.length,
                              (index) {
                                Map<String, dynamic> setting =
                                    state.notifications[index];
                                return NotificationSettingCard(
                                  name: setting['currencyName'],
                                  criteria: setting['criteria'],
                                  percent:
                                      setting['criteriaPercent'].toDouble(),
                                );
                              },
                            ),
                            const SizedBox(height: 50)
                          ],
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PriceCategory extends StatelessWidget {
  const PriceCategory({
    Key? key,
    required this.category,
    required this.percent,
  }) : super(key: key);

  final String category;
  final double percent;

  @override
  Widget build(BuildContext context) {
    double kFont = 17;
    return Padding(
      padding: EdgeInsets.all(kPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: TextStyle(
              color: kTextColor,
              fontSize: kFont,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${percent.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: kFont,
                  color: determineColor(
                    percent,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                determineIcon(
                  percent,
                ),
                color: determineColor(
                  percent,
                ),
                size: kFont,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CryptoCurrencyPrice extends StatelessWidget {
  const CryptoCurrencyPrice({
    Key? key,
    required this.cryptoCurrency,
  }) : super(key: key);

  final CryptoCurrency cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    return Column(
      children: [
        Text(
          '\$${numberFormat.format(cryptoCurrency.price)}',
          style: TextStyle(
            color: kTextColor,
            fontSize: 32,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${cryptoCurrency.percentChange24Hour.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 16,
                color: determineColor(
                  cryptoCurrency.percentChange24Hour,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              determineIcon(
                cryptoCurrency.percentChange24Hour,
              ),
              color: determineColor(
                cryptoCurrency.percentChange24Hour,
              ),
              size: 16,
            ),
          ],
        ),
      ],
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
              height: 150,
              child: Image.asset(
                'assets/images/${logos[symbol]}',
              ),
            )
          : Container(
              height: 150,
              width: 150,
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

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
    required this.name,
    required this.symbol,
  }) : super(key: key);

  final String name;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            color: kTextColor,
            fontSize: 24,
          ),
        ),
        Text(
          symbol,
          style: TextStyle(
            color: kAccentColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// import 'package:crypto_prices/cubit/asset_cubit.dart';
// import 'package:crypto_prices/cubit/favorite_item_cubit.dart';
// import 'package:crypto_prices/cubit/info_screen_cubit.dart';
// import 'package:crypto_prices/cubit/notification_cubit.dart';
// import 'package:crypto_prices/data/database/database_controller.dart';
// import 'package:crypto_prices/data/logos.dart';
// import 'package:crypto_prices/data/models/asset.dart';
// import 'package:crypto_prices/ui/cards/notification_setting_card.dart';
// import 'package:crypto_prices/ui/screens/create_notification_screen.dart';
// import 'package:crypto_prices/ui/screens/delete_notification_screen.dart';
// import 'package:crypto_prices/ui/screens/home_screen.dart';
// import 'package:crypto_prices/utils/utilities.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';

// class FavoriteItemScreen extends StatefulWidget {
//   const FavoriteItemScreen({
//     Key? key,
//     required this.name,
//     required this.symbol,
//     required this.isFavorited,
//     required this.userID,
//     required this.screenID,
//   }) : super(key: key);

//   final String name;
//   final String symbol;
//   final bool isFavorited;
//   final int userID;
//   final int screenID;

//   @override
//   State<FavoriteItemScreen> createState() => _FavoriteItemScreenState();
// }

// class _FavoriteItemScreenState extends State<FavoriteItemScreen> {
//   DatabaseController db = DatabaseController();
//   late bool isFavorited;
//   late InfoScreenCubit _infoCubit;
//   late NotificationCubit _notificationCubit;
//   double kFont = 17;

//   @override
//   void initState() {
//     super.initState();
//     isFavorited = widget.isFavorited;
//     _infoCubit = InfoScreenCubit(symbol: widget.symbol);
//     _notificationCubit = NotificationCubit(
//       userID: widget.userID,
//       screenID: widget.screenID,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<InfoScreenCubit>(
//           create: (context) => _infoCubit,
//         ),
//         BlocProvider<NotificationCubit>(
//           create: (context) => _notificationCubit,
//         ),
//       ],
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.black,
//           automaticallyImplyLeading: true,
//           centerTitle: true,
//           title: AppBarTitle(name: widget.name, symbol: widget.symbol),
//           actions: [
//             GestureDetector(
//               onTap: () async {
//                 bool isInList =
//                     await db.checkForFavoriteItemSymbol(widget.symbol);
//                 setState(() {
//                   if (isInList) {
//                     isFavorited = false;
//                     BlocProvider.of<FavoriteItemCubit>(context)
//                         .removeFavoriteItemSymbol(
//                       widget.symbol,
//                       widget.userID,
//                     );
//                     //BlocProvider.of<AssetCubit>(context).rebuild();
//                   } else {
//                     isFavorited = true;
//                     BlocProvider.of<FavoriteItemCubit>(context)
//                         .addFavoriteItemSymbol(
//                       widget.name,
//                       widget.symbol,
//                       widget.userID,
//                     );
//                     //BlocProvider.of<AssetCubit>(context).rebuild();
//                   }
//                 });
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 16.0),
//                 child: Container(
//                   height: 22,
//                   width: 22,
//                   color: Colors.transparent,
//                   child: Center(
//                     child: Icon(
//                       isFavorited ? Icons.star : Icons.star_outline,
//                       color: Colors.yellow,
//                       size: 22,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           decoration: const BoxDecoration(
//             color: Colors.black,
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Colors.black,
//                 Colors.black,
//                 Color(0xFF081b4b),
//               ],
//             ),
//           ),
//           child: BlocBuilder<InfoScreenCubit, InfoScreenState>(
//             builder: (_, state) {
//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 16),
//                     AssetLogo(symbol: widget.symbol),
//                     const SizedBox(height: 32),
//                     AssetPrice(asset: state.asset),
//                     const SizedBox(height: 32),
//                     const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Divider(
//                         color: Colors.white,
//                         height: 16,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Marketcap',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: kFont,
//                             ),
//                           ),
//                           Text(
//                             trimDollars(
//                                 '\$${numberFormat.format(state.asset.marketCap)}'),
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: kFont,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Diluted marketcap',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: kFont,
//                             ),
//                           ),
//                           Text(
//                             trimDollars(
//                                 '\$${numberFormat.format(state.asset.fullyDilutedMarketCap)}'),
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: kFont,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Marketcap rank',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: kFont,
//                             ),
//                           ),
//                           Text(
//                             '${state.asset.cmcRank}',
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: kFont,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Marketcap dominance',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: kFont,
//                             ),
//                           ),
//                           Text(
//                             '${state.asset.marketCapDominance}%',
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: kFont,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Divider(
//                         color: Colors.white,
//                         //height: 16,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Max supply',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: kFont,
//                             ),
//                           ),
//                           Text(
//                             state.asset.maxSupply == null
//                                 ? 'Infinite'
//                                 : numberFormat
//                                     .format(state.asset.maxSupply)
//                                     .toString(),
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: kFont,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Circulating',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: kFont,
//                             ),
//                           ),
//                           Text(
//                             numberFormat
//                                 .format(state.asset.circulatingSupply)
//                                 .toString(),
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: kFont,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Total supply',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: kFont,
//                             ),
//                           ),
//                           Text(
//                             numberFormat
//                                 .format(state.asset.totalSupply)
//                                 .toString(),
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: kFont,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Divider(
//                         color: Colors.white,
//                         //height: 16,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(25),
//                           ),
//                           color: const Color(0xFF081b4b).withOpacity(0.5),
//                         ),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Volume',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: kFont,
//                                     ),
//                                   ),
//                                   Text(
//                                     '\$${numberFormat.format(state.asset.volume24h)}',
//                                     style: TextStyle(
//                                       color: Colors.green,
//                                       fontSize: kFont,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Volume change 24h',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: kFont,
//                                     ),
//                                   ),
//                                   Text(
//                                     '${state.asset.percentVolumeChange24h}%',
//                                     style: TextStyle(
//                                       color: determineColor(
//                                           state.asset.percentVolumeChange24h),
//                                       fontSize: kFont,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF081b4b).withOpacity(0.5),
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(25)),
//                         ),
//                         child: Column(
//                           children: [
//                             PriceCategory(
//                               category: '1 hour',
//                               percent: state.asset.percentChange1Hour,
//                             ),
//                             PriceCategory(
//                               category: '1 day',
//                               percent: state.asset.percentChange24Hour,
//                             ),
//                             PriceCategory(
//                               category: '7 days',
//                               percent: state.asset.percentChange7Day,
//                             ),
//                             PriceCategory(
//                               category: '30 days',
//                               percent: state.asset.percentChange30Day,
//                             ),
//                             PriceCategory(
//                               category: '60 days',
//                               percent: state.asset.percentChange60Day,
//                             ),
//                             PriceCategory(
//                               category: '90 days',
//                               percent: state.asset.percentChange90Day,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Divider(
//                         color: Colors.white,
//                         //height: 16,
//                       ),
//                     ),
//                     BlocBuilder<NotificationCubit, NotificationState>(
//                       builder: (_, state) {
//                         return Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Notifications',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 22,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       if (state.settings.isEmpty) {
//                                       } else {
//                                         Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                             builder: (_) {
//                                               return BlocProvider.value(
//                                                 value: _notificationCubit,
//                                                 child: DeleteNotificationScreen(
//                                                   userID: widget.userID,
//                                                   screenID: widget.screenID,
//                                                   name: widget.name,
//                                                   symbol: widget.symbol,
//                                                   settings: state.settings,
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         );
//                                       }
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFF081b4b)
//                                             .withOpacity(0.5),
//                                         borderRadius: const BorderRadius.all(
//                                           Radius.circular(25),
//                                         ),
//                                       ),
//                                       child: const Padding(
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: 16.0,
//                                           vertical: 8.0,
//                                         ),
//                                         child: Text(
//                                           'Delete',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 18,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                           builder: (_) {
//                                             return BlocProvider.value(
//                                               value: _notificationCubit,
//                                               child: CreateNotificationScreen(
//                                                 userID: widget.userID,
//                                                 screenID: widget.screenID,
//                                                 currencyName: widget.name,
//                                                 symbol: widget.symbol,
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       );
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFF081b4b)
//                                             .withOpacity(0.5),
//                                         borderRadius: const BorderRadius.all(
//                                           Radius.circular(25),
//                                         ),
//                                       ),
//                                       child: const Padding(
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: 16.0,
//                                           vertical: 8.0,
//                                         ),
//                                         child: Text(
//                                           'Add',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 18,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     BlocBuilder<NotificationCubit, NotificationState>(
//                       builder: (_, state) {
//                         return Column(
//                           children: [
//                             ...List.generate(
//                               state.settings.length,
//                               (index) {
//                                 Map<String, dynamic> setting =
//                                     state.settings[index];
//                                 return NotificationSettingCard(
//                                   name: setting['currencyName'],
//                                   criteria: setting['criteria'],
//                                   percent:
//                                       setting['criteriaPercent'].toDouble(),
//                                 );
//                               },
//                             ),
//                             const SizedBox(height: 50)
//                           ],
//                         );
//                       },
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PriceCategory extends StatelessWidget {
//   const PriceCategory({
//     Key? key,
//     required this.category,
//     required this.percent,
//   }) : super(key: key);

//   final String category;
//   final double percent;

//   @override
//   Widget build(BuildContext context) {
//     double kFont = 17;
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             category,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: kFont,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 '${percent.toStringAsFixed(2)}%',
//                 style: TextStyle(
//                   fontSize: kFont,
//                   color: determineColor(
//                     percent,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Icon(
//                 determineIcon(
//                   percent,
//                 ),
//                 color: determineColor(
//                   percent,
//                 ),
//                 size: kFont,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AssetPrice extends StatelessWidget {
//   const AssetPrice({
//     Key? key,
//     required this.asset,
//   }) : super(key: key);

//   final Asset asset;

//   @override
//   Widget build(BuildContext context) {
//     final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
//     return Column(
//       children: [
//         Text(
//           '\$${numberFormat.format(asset.price)}',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 32,
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               '${asset.percentChange24Hour.toStringAsFixed(2)}%',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: determineColor(
//                   asset.percentChange24Hour,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 4),
//             Icon(
//               determineIcon(
//                 asset.percentChange24Hour,
//               ),
//               color: determineColor(
//                 asset.percentChange24Hour,
//               ),
//               size: 16,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class AssetLogo extends StatelessWidget {
//   const AssetLogo({
//     Key? key,
//     required this.symbol,
//   }) : super(key: key);

//   final String symbol;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: logos.containsKey(symbol)
//           ? SizedBox(
//               height: 150,
//               child: Image.asset(
//                 'assets/images/${logos[symbol]}',
//               ),
//             )
//           : Container(
//               height: 150,
//               width: 150,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: Colors.white,
//                   width: 1,
//                 ),
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.question_mark,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//     );
//   }
// }

// class AppBarTitle extends StatelessWidget {
//   const AppBarTitle({
//     Key? key,
//     required this.name,
//     required this.symbol,
//   }) : super(key: key);

//   final String name;
//   final String symbol;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           name,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//           ),
//         ),
//         Text(
//           symbol,
//           style: const TextStyle(
//             color: Colors.grey,
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }
// }
