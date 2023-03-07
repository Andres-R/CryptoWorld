import 'package:bloc/bloc.dart';
import 'package:crypto_world/data/models/crypto_currency_model.dart';
import 'package:crypto_world/data/service/data_service.dart';
import 'package:equatable/equatable.dart';

part 'crypto_currencies_state.dart';

class CryptoCurrenciesCubit extends Cubit<CryptoCurrenciesState> {
  CryptoCurrenciesCubit()
      : super(const CryptoCurrenciesState(cryptoCurrencies: [])) {
    initializeCryptoCurrencies();
  }

  DataService dataService = DataService();

  void initializeCryptoCurrencies() async {
    List<CryptoCurrency> currencies = await dataService.getCryptoCurrencies();
    emit(CryptoCurrenciesState(cryptoCurrencies: currencies));
  }
}
