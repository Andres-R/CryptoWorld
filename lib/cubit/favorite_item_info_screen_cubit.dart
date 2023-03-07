import 'package:bloc/bloc.dart';
import 'package:crypto_world/data/models/crypto_currency_model.dart';
import 'package:crypto_world/data/service/data_service.dart';
import 'package:equatable/equatable.dart';

part 'favorite_item_info_screen_state.dart';

class FavoriteItemInfoScreenCubit extends Cubit<FavoriteItemInfoScreenState> {
  FavoriteItemInfoScreenCubit({
    required this.symbol,
  }) : super(
          FavoriteItemInfoScreenState(
            cryptoCurrency: CryptoCurrency(
              id: 1,
              name: 'name',
              symbol: 'symbol',
              price: 1.0,
              percentChange1Hour: 0.0,
              percentChange24Hour: 0.0,
              percentChange7Day: 0.0,
              percentChange30Day: 0.0,
              percentChange60Day: 0.0,
              percentChange90Day: 0.0,
              marketCap: 0.0,
              marketCapDominance: 0.0,
              fullyDilutedMarketCap: 0.0,
              volume24h: 0.0,
              percentVolumeChange24h: 0.0,
              maxSupply: 0.0,
              circulatingSupply: 0.0,
              totalSupply: 0.0,
              cmcRank: 1,
            ),
          ),
        ) {
    initializeInfo();
  }

  DataService dataService = DataService();
  String symbol;

  void initializeInfo() async {
    CryptoCurrency cryptoCurrency =
        await dataService.getCryptoCurrencyInformation(symbol);
    emit(FavoriteItemInfoScreenState(cryptoCurrency: cryptoCurrency));
  }
}
