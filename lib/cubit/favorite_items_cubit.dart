import 'package:bloc/bloc.dart';
import 'package:crypto_world/data/models/crypto_currency_model.dart';
import 'package:crypto_world/data/repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'favorite_items_state.dart';

class FavoriteItemsCubit extends Cubit<FavoriteItemsState> {
  FavoriteItemsCubit({
    required this.userID,
  }) : super(const FavoriteItemsState(favoriteItems: [])) {
    initializeFavoriteItems();
  }

  DataRepository dataRepository = DataRepository();
  String userID;

  void initializeFavoriteItems() async {
    List<Map<String, dynamic>> items =
        await dataRepository.getFavoriteItems(userID);
    emit(FavoriteItemsState(favoriteItems: items));
  }

  void addFavoriteItem(CryptoCurrency currency, String userID) async {
    bool isInList = await dataRepository.checkForFavoriteItem(currency, userID);
    if (!isInList) {
      await dataRepository.addFavoriteItem(currency, userID);
      List<Map<String, dynamic>> items =
          await dataRepository.getFavoriteItems(userID);
      emit(FavoriteItemsState(favoriteItems: items));
    }
  }

  void addFavoriteItemSymbol(String name, String symbol, String userID) async {
    bool isInList =
        await dataRepository.checkForFavoriteItemSymbol(symbol, userID);
    if (!isInList) {
      await dataRepository.addFavoriteItemSymbol(name, symbol, userID);
      List<Map<String, dynamic>> items =
          await dataRepository.getFavoriteItems(userID);
      emit(FavoriteItemsState(favoriteItems: items));
    }
  }

  void removeFavoriteItem(CryptoCurrency currency, String userID) async {
    bool isInList = await dataRepository.checkForFavoriteItem(currency, userID);
    if (isInList) {
      await dataRepository.removeFavoriteItem(currency, userID);
      await dataRepository.deleteNotificationSettings(currency.symbol, userID);
      List<Map<String, dynamic>> items =
          await dataRepository.getFavoriteItems(userID);
      emit(FavoriteItemsState(favoriteItems: items));
    }
  }

  void removeFavoriteItemSymbol(String symbol, String userID) async {
    bool isInList =
        await dataRepository.checkForFavoriteItemSymbol(symbol, userID);
    if (isInList) {
      await dataRepository.removeFavoriteItemSymbol(symbol, userID);
      await dataRepository.deleteNotificationSettings(symbol, userID);
      List<Map<String, dynamic>> items =
          await dataRepository.getFavoriteItems(userID);
      emit(FavoriteItemsState(favoriteItems: items));
    }
  }
}
