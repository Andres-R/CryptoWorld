part of 'crypto_currencies_cubit.dart';

class CryptoCurrenciesState extends Equatable {
  const CryptoCurrenciesState({
    required this.cryptoCurrencies,
  });

  final List<CryptoCurrency> cryptoCurrencies;

  @override
  List<Object> get props => [cryptoCurrencies];
}
