part of 'favorite_items_cubit.dart';

class FavoriteItemsState extends Equatable {
  const FavoriteItemsState({
    required this.favoriteItems,
  });

  final List<Map<String, dynamic>> favoriteItems;

  @override
  List<Object> get props => [favoriteItems];
}
