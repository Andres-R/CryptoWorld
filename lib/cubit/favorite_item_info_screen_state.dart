part of 'favorite_item_info_screen_cubit.dart';

class FavoriteItemInfoScreenState extends Equatable {
  const FavoriteItemInfoScreenState({
    required this.cryptoCurrency,
  });

  final CryptoCurrency cryptoCurrency;

  @override
  List<Object> get props => [cryptoCurrency];
}
