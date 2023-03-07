import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_world/cubit/favorite_items_cubit.dart';
import 'package:crypto_world/data/repository/data_repository.dart';
import 'package:crypto_world/main.dart';
import 'package:crypto_world/ui/cards/favorite_item_card.dart';
import 'package:crypto_world/ui/screens/general/crypto_currencies_list_screen.dart';
import 'package:crypto_world/ui/screens/general/favorite_item_info_screen.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:crypto_world/utils/logos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataRepository db = DataRepository();
  late FavoriteItemsCubit _favoriteItemsCubit;
  late FirebaseAuth fbaInstance;

  @override
  void initState() {
    super.initState();
    fbaInstance = FirebaseAuth.instance;
    _favoriteItemsCubit = FavoriteItemsCubit(userID: widget.userID);
  }

  // int mySortComparison(Asset a, Asset b) {
  //   if (a.marketCap < b.marketCap) {
  //     return 1;
  //   } else if (a.marketCap > b.marketCap) {
  //     return -1;
  //   } else {
  //     return 0;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteItemsCubit>(
          create: (context) => _favoriteItemsCubit,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: kMainBGColor,
          title: const AppBarTitle(),
        ),
        body: Container(
          decoration: BoxDecoration(
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
                SizedBox(height: kPadding * 2),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: kPadding,
                    horizontal: kPadding * 3,
                  ),
                  child: Center(
                    child: Text(
                      'View all of your favorite cryptocurrencies from one place',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const LogoCollection(),
                SizedBox(height: kPadding * 2),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: Row(
                    children: [
                      Text(
                        'Favorites',
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<FavoriteItemsCubit, FavoriteItemsState>(
                  builder: (_, state) {
                    if (state.favoriteItems.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(kPadding),
                        child: Center(
                          child: Text(
                            'Add currencies to your favorites list and setup custom notifications',
                            style: TextStyle(
                              color: kAccentColor,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: kPadding / 2),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...List.generate(
                              state.favoriteItems.length,
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return BlocProvider.value(
                                            value: _favoriteItemsCubit,
                                            child: FavoriteItemInfoScreen(
                                              name: state.favoriteItems[index]
                                                  ['currencyName'],
                                              symbol: state.favoriteItems[index]
                                                  ['currencySymbol'],
                                              isFavorited: true,
                                              userID: widget.userID,
                                              screenID: state
                                                  .favoriteItems[index]['id'],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: FavoriteItemCard(
                                    name: state.favoriteItems[index]
                                        ['currencyName'],
                                    symbol: state.favoriteItems[index]
                                        ['currencySymbol'],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: Row(
                    children: [
                      Text(
                        'View cryptocurrencies',
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return BlocProvider.value(
                              value: _favoriteItemsCubit,
                              child: CryptoCurrenciesListScreen(
                                userID: widget.userID,
                                sortCriteria: 'Marketcap',
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: const ButtonContainer(title: 'Marketcap'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return BlocProvider.value(
                              value: _favoriteItemsCubit,
                              child: CryptoCurrenciesListScreen(
                                userID: widget.userID,
                                sortCriteria: 'Price',
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: const ButtonContainer(title: 'Price'),
                  ),
                ),

                // BlocBuilder<AssetCubit, AssetState>(
                //   builder: (_, assetState) {
                //     List<Asset> assets = [];
                //     for (Asset a in assetState.assets) {
                //       assets.add(a);
                //     }
                //     assets.sort(mySortComparison);
                //     return BlocBuilder<FavoriteItemCubit, FavoriteItemState>(
                //       builder: (_, favoriteState) {
                //         return Column(
                //           children: [
                //             ...List.generate(
                //               assets.length,
                //               (index) {
                //                 bool isFavorited = false;
                //                 for (Map map in favoriteState.assets) {
                //                   if (map['currencySymbol'] ==
                //                       assets[index].symbol) {
                //                     isFavorited = true;
                //                   }
                //                 }
                //                 Asset asset = assets[index];
                //                 return BlocProvider.value(
                //                   value: _favoriteItemCubit,
                //                   child: AssetCard(
                //                     asset: asset,
                //                     isFavorited: isFavorited,
                //                   ),
                //                 );
                //               },
                //             ),
                //           ],
                //         );
                //       },
                //     );
                //   },
                // ),
                // -----
                //
                //
                // -----
                // BlocBuilder<AssetCubit, AssetState>(
                //   builder: (_, assetState) {
                //     return BlocConsumer<FavoriteItemCubit, FavoriteItemState>(
                //       listener: (_, listenState) {
                //         if (listenState.rebuildFavorites) {
                //           _assetCubit.rebuild();
                //           //_favoriteItemCubit.rebuildFavorites();
                //         }
                //       },
                //       builder: (_, favoriteState) {
                //         List<Asset> assets = [];
                //         for (Asset a in assetState.assets) {
                //           assets.add(a);
                //         }
                //         assets.sort(mySortComparison);
                //         return Column(
                //           children: [
                //             ...List.generate(
                //               assets.length,
                //               (index) {
                //                 bool isFavorited = false;
                //                 for (Map map in favoriteState.assets) {
                //                   if (map['currencySymbol'] ==
                //                       assets[index].symbol) {
                //                     isFavorited = true;
                //                   }
                //                 }
                //                 Asset asset = assets[index];
                //                 return BlocProvider.value(
                //                   value: _favoriteItemCubit,
                //                   child: AssetCard(
                //                     asset: asset,
                //                     isFavorited: isFavorited,
                //                   ),
                //                 );
                //               },
                //             ),
                //           ],
                //         );
                //       },
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogoCollection extends StatelessWidget {
  const LogoCollection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cheight = 300;
    double dith = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: cheight,
          //color: Colors.blue,
        ),
        SizedBox(
          height: 80,
          child: Image.asset(
            'assets/images/${logos['BTC']}',
          ),
        ),
        Positioned(
          bottom: cheight * 0.4,
          right: dith * 0.2,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(15 / 360),
            child: SizedBox(
              height: 60,
              child: Image.asset(
                'assets/images/${logos['SOL']}',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: cheight * 0.6,
          left: dith * 0.2,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-15 / 360),
            child: SizedBox(
              height: 60,
              child: Image.asset(
                'assets/images/${logos['USDT']}',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: cheight * 0.25,
          left: dith * 0.2,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-5 / 360),
            child: SizedBox(
              height: 90,
              child: Image.asset(
                'assets/images/${logos['ETH']}',
              ),
            ),
          ),
        ),
        Positioned(
          top: cheight * 0.15,
          right: dith * 0.25,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-5 / 360),
            child: SizedBox(
              height: 70,
              child: Image.asset(
                'assets/images/${logos['BNB']}',
              ),
            ),
          ),
        ),
        Positioned(
          top: cheight * 0.15,
          right: dith * 0.25,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-5 / 360),
            child: SizedBox(
              height: 70,
              child: Image.asset(
                'assets/images/${logos['BNB']}',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: cheight * 0.15,
          right: dith * 0.5,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(20 / 360),
            child: SizedBox(
              height: 50,
              child: Image.asset(
                'assets/images/${logos['AVAX']}',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: cheight * 0.20,
          left: dith * 0.57,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(20 / 360),
            child: SizedBox(
              height: 50,
              child: Image.asset(
                'assets/images/${logos['ADA']}',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: cheight * 0.12,
          right: dith * 0.2,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(110 / 360),
            child: SizedBox(
              height: 40,
              child: Image.asset(
                'assets/images/${logos['MATIC']}',
              ),
            ),
          ),
        ),
        Positioned(
          top: cheight * 0.15,
          left: dith * 0.4,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(0 / 360),
            child: SizedBox(
              height: 50,
              child: Image.asset(
                'assets/images/${logos['FLOW']}',
              ),
            ),
          ),
        ),
        Positioned(
          top: cheight * 0.4,
          left: dith * 0.1,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(0 / 360),
            child: SizedBox(
              height: 50,
              child: Image.asset(
                'assets/images/${logos['APE']}',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: cheight * 0.2,
          left: dith * 0.15,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-30 / 360),
            child: SizedBox(
              height: 40,
              child: Image.asset(
                'assets/images/${logos['DOGE']}',
              ),
            ),
          ),
        ),
        Positioned(
          top: cheight * 0.3,
          right: dith * 0.15,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(-20 / 360),
            child: SizedBox(
              height: 30,
              child: Image.asset(
                'assets/images/${logos['DOT']}',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: kDarkBlue.withOpacity(0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(kRadiusCurve),
        ),
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Color(0xFF081b4b),
        //     Colors.black,
        //     Color(0xFF081b4b),
        //   ],
        // ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: kTextColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Crypto World',
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        Text(
          'Today',
          style: TextStyle(
            color: kAccentColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
