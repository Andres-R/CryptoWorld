import 'package:crypto_world/cubit/crypto_currencies_cubit.dart';
import 'package:crypto_world/cubit/favorite_items_cubit.dart';
import 'package:crypto_world/data/models/crypto_currency_model.dart';
import 'package:crypto_world/ui/cards/crypto_currency_card.dart';
import 'package:crypto_world/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptoCurrenciesListScreen extends StatefulWidget {
  const CryptoCurrenciesListScreen({
    Key? key,
    required this.userID,
    required this.sortCriteria,
  }) : super(key: key);

  final String userID;
  final String sortCriteria;

  @override
  State<CryptoCurrenciesListScreen> createState() =>
      _CryptoCurrenciesListScreenState();
}

class _CryptoCurrenciesListScreenState
    extends State<CryptoCurrenciesListScreen> {
  late CryptoCurrenciesCubit _cryptoCurrenciesCubit;

  @override
  void initState() {
    super.initState();
    _cryptoCurrenciesCubit = CryptoCurrenciesCubit();
  }

  int sortComparison(CryptoCurrency a, CryptoCurrency b) {
    if (widget.sortCriteria == 'Price') {
      if (a.price < b.price) {
        return 1;
      } else if (a.price > b.price) {
        return -1;
      } else {
        return 0;
      }
    } else {
      if (a.marketCap < b.marketCap) {
        return 1;
      } else if (a.marketCap > b.marketCap) {
        return -1;
      } else {
        return 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CryptoCurrenciesCubit>(
      create: (context) => _cryptoCurrenciesCubit,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kMainBGColor,
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: Text(
            widget.sortCriteria,
            style: TextStyle(
              color: kTextColor,
              fontSize: 24,
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
                BlocBuilder<CryptoCurrenciesCubit, CryptoCurrenciesState>(
                  builder: (_, assetState) {
                    List<CryptoCurrency> assets = [];
                    for (CryptoCurrency a in assetState.cryptoCurrencies) {
                      assets.add(a);
                    }
                    assets.sort(sortComparison);
                    return BlocBuilder<FavoriteItemsCubit, FavoriteItemsState>(
                      builder: (_, favoriteState) {
                        return Column(
                          children: [
                            ...List.generate(
                              assets.length,
                              (index) {
                                bool isFavorited = false;
                                for (CryptoCurrency cc
                                    in favoriteState.favoriteItems) {
                                  if (cc.symbol == assets[index].symbol) {
                                    isFavorited = true;
                                  }
                                }
                                CryptoCurrency currency = assets[index];
                                return BlocProvider.value(
                                  value: BlocProvider.of<FavoriteItemsCubit>(
                                      context),
                                  child: CryptoCurrencyCard(
                                    cryptoCurrency: currency,
                                    isFavorited: isFavorited,
                                    userID: widget.userID,
                                    showFavoriteStar: true,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
