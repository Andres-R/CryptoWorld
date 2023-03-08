part of 'favorite_items_cubit.dart';

class FavoriteItemsState extends Equatable {
  const FavoriteItemsState({
    required this.favoriteItems,
  });

  final List<CryptoCurrency> favoriteItems;

  @override
  List<Object> get props => [favoriteItems];
}
