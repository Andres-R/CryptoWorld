import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_world/data/models/crypto_currency_model.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class DataRepository {
  Future createUser(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    Map<String, dynamic> user = {
      'userID': docUser.id,
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'password': password,
    };

    await docUser.set(user);
  }

  // works? [yes]
  Future addNotificationSetting(
    String name,
    String symbol,
    String criteria,
    double criteriaPercent,
    String userID,
    String screenID,
  ) async {
    final docUser =
        FirebaseFirestore.instance.collection('notifications').doc();

    Map<String, dynamic> item = {
      'id': docUser.id,
      'currencyName': name,
      'currencySymbol': symbol,
      'criteria': criteria,
      'criteriaPercent': criteriaPercent,
      'userID': userID,
      'screenID': screenID,
    };

    await docUser.set(item);
  }

  // works? [yes]
  Future<List<Map<String, dynamic>>> getNotificationSettings(
    String userID,
    String screenID,
  ) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('notifications')
        .where('userID', isEqualTo: userID)
        .where('screenID', isEqualTo: screenID)
        .get();

    List<Map<String, dynamic>> list = snapshot.docs.map((doc) {
      return doc.data(); // doc.data() is a Map<String, dynamic>
    }).toList();
    return list;
  }

  // works? [yes]
  Future addFavoriteItem(
    CryptoCurrency cryptoCurrency,
    String userID,
  ) async {
    final docUser =
        FirebaseFirestore.instance.collection('favorite_items').doc();

    Map<String, dynamic> item = {
      'id': docUser.id,
      'currencyName': cryptoCurrency.name,
      'currencySymbol': cryptoCurrency.symbol,
      'userID': userID,
    };

    await docUser.set(item);
  }

  // works? [yes]
  Future addFavoriteItemSymbol(
    String name,
    String symbol,
    String userID,
  ) async {
    final docUser =
        FirebaseFirestore.instance.collection('favorite_items').doc();

    Map<String, dynamic> item = {
      'id': docUser.id,
      'currencyName': name,
      'currencySymbol': symbol,
      'userID': userID,
    };

    await docUser.set(item);
  }

  // works? [yes]
  Future<List<CryptoCurrency>> getFavoriteItems(String userID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('favorite_items')
        .where('userID', isEqualTo: userID)
        .get();

    // this will return favorite items as maps from firebase
    List<Map<String, dynamic>> list = snapshot.docs.map((doc) {
      return doc.data(); // doc.data() is a Map<String, dynamic>
    }).toList();

    // this will return favorite items as CryptoCurrency objects
    // note: more data will be saved now other than just
    //       {id: currencyName: currencySymbol: userID:}
    List<CryptoCurrency> currencies = [];

    String key1 = "172d5f64-3e8e-42ed-8728-e3616d2a5ef9";
    String key2 = "1ee1f4c0-feb3-4e5e-8d9d-7efcbb7d2d12";
    String key3 = "6971863c-0d2c-4a4a-a8ef-7cc712618a73";
    String key4 = "9c33d992-236d-458c-8c57-01f8b7422e36";
    String key5 = "e779b0e8-c8e0-4eff-8669-1e8a32b455bb";
    String key6 = "8026fe7a-03dc-4717-b1a2-f48d65fa9926";
    late List<String> mainKey = [
      key1,
      key2,
      key3,
      key4,
      key5,
      key6,
    ];
    int keyInc = 0;

    String baseURL = "https://pro-api.coinmarketcap.com/v2";
    String category = "/cryptocurrency/quotes/latest";
    String parameter2 = "&CMC_PRO_API_KEY=";

    for (dynamic item in list) {
      String parameter1 = "?symbol=${item['currencySymbol']}";
      String endpoint =
          "$baseURL$category$parameter1$parameter2${mainKey[(keyInc) % mainKey.length]}";
      keyInc++;

      CryptoCurrency cryptoCurrency = CryptoCurrency(
        id: '1',
        name: 'name',
        symbol: 'symbol',
        price: 'price',
        percentChange1Hour: 'percentChange_1h',
        percentChange24Hour: 'percentChange_24h',
        percentChange7Day: 'percentChange_7d',
        percentChange30Day: 'percentChange_30d',
        percentChange60Day: 'percentChange_60d',
        percentChange90Day: 'percentChange_90d',
        marketCap: 'marketCap',
        marketCapDominance: 'marketCapDominance',
        fullyDilutedMarketCap: 'fullyDilutedMarketCap',
        volume24h: 'volume24h',
        percentVolumeChange24h: 'percentVolumeChange24h',
        maxSupply: 'maxSupply',
        circulatingSupply: 'circulatingSupply',
        totalSupply: 'totalSupply',
        cmcRank: 1,
      );

      try {
        Uri uri = Uri.parse(endpoint);
        Response response = await http.get(uri);
        Map<String, dynamic> json = jsonDecode(response.body);
        Map<String, dynamic> data = json['data'];

        List<dynamic> info = data[item['currencySymbol']];

        Map<String, dynamic> map = info[0];

        // This id is from API request, we want the id for this
        // currency to be the id from OUR database.
        //
        // int id = map['id'];

        // This is the proper id we want. This id is from our database and is used to
        // map notifications to screen when user clicks on favorite_item_card
        String id = item['id'];

        String name = map['name'];
        String symbol = map['symbol'];

        dynamic maxSupply = map['max_supply'];
        dynamic circulatingSupply = map['circulating_supply'];
        dynamic totalSupply = map['total_supply'];
        dynamic cmcRank = map['cmc_rank'];

        Map<String, dynamic> quote = map['quote'];
        Map<String, dynamic> usd = quote['USD'];

        dynamic price = usd['price'];
        dynamic percentChange_1h = usd['percent_change_1h'];
        dynamic percentChange_24h = usd['percent_change_24h'];
        dynamic percentChange_7d = usd['percent_change_7d'];
        dynamic percentChange_30d = usd['percent_change_30d'];
        dynamic percentChange_60d = usd['percent_change_60d'];
        dynamic percentChange_90d = usd['percent_change_90d'];
        dynamic marketCap = usd['market_cap'];
        dynamic marketCapDominance = usd['market_cap_dominance'];
        dynamic fullyDilutedMarketCap = usd['fully_diluted_market_cap'];
        dynamic volume24h = usd['volume_24h'];
        dynamic percentVolumeChange24h = usd['volume_change_24h'];

        cryptoCurrency = CryptoCurrency(
          id: id,
          name: name,
          symbol: symbol,
          price: price,
          percentChange1Hour: percentChange_1h,
          percentChange24Hour: percentChange_24h,
          percentChange7Day: percentChange_7d,
          percentChange30Day: percentChange_30d,
          percentChange60Day: percentChange_60d,
          percentChange90Day: percentChange_90d,
          marketCap: marketCap,
          marketCapDominance: marketCapDominance,
          fullyDilutedMarketCap: fullyDilutedMarketCap,
          volume24h: volume24h,
          percentVolumeChange24h: percentVolumeChange24h,
          maxSupply: maxSupply,
          circulatingSupply: circulatingSupply,
          totalSupply: totalSupply,
          cmcRank: cmcRank,
        );
      } catch (e) {
        print(e);
      }
      currencies.add(cryptoCurrency);
    }

    return currencies;
  }

  // works? [yes]
  Future removeFavoriteItem(
    CryptoCurrency cryptoCurrency,
    String userID,
  ) async {
    QuerySnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
        .instance
        .collection('favorite_items')
        .where('userID', isEqualTo: userID)
        .where('currencySymbol', isEqualTo: cryptoCurrency.symbol)
        .get();

    List<Map<String, dynamic>> list = docUser.docs.map((doc) {
      return doc.data();
    }).toList();

    await FirebaseFirestore.instance
        .collection('favorite_items')
        .doc(list[0]['id'])
        .delete();
  }

  // works? [yes]
  Future removeFavoriteItemSymbol(
    String symbol,
    String userID,
  ) async {
    QuerySnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
        .instance
        .collection('favorite_items')
        .where('userID', isEqualTo: userID)
        .where('currencySymbol', isEqualTo: symbol)
        .get();

    List<Map<String, dynamic>> list = docUser.docs.map((doc) {
      return doc.data();
    }).toList();

    await FirebaseFirestore.instance
        .collection('favorite_items')
        .doc(list[0]['id'])
        .delete();
  }

  // works? [yes]
  // *** added userID ***
  Future<bool> checkForFavoriteItem(
    CryptoCurrency cryptoCurrency,
    String userID,
  ) async {
    QuerySnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
        .instance
        .collection('favorite_items')
        .where('userID', isEqualTo: userID)
        .where('currencySymbol', isEqualTo: cryptoCurrency.symbol)
        .get();

    List<Map<String, dynamic>> list = docUser.docs.map((doc) {
      return doc.data();
    }).toList();

    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // works? [yes]
  // *** added userID ***
  Future<bool> checkForFavoriteItemSymbol(
    String symbol,
    String userID,
  ) async {
    QuerySnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
        .instance
        .collection('favorite_items')
        .where('userID', isEqualTo: userID)
        .where('currencySymbol', isEqualTo: symbol)
        .get();

    List<Map<String, dynamic>> list = docUser.docs.map((doc) {
      return doc.data();
    }).toList();

    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // works? [yes]
  // *** added userID ***
  Future deleteNotificationSettings(
    String symbol,
    String userID,
  ) async {
    QuerySnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
        .instance
        .collection('notifications')
        .where('currencySymbol', isEqualTo: symbol)
        .where('userID', isEqualTo: userID)
        .get();

    List<Map<String, dynamic>> list = docUser.docs.map((doc) {
      return doc.data();
    }).toList();

    for (Map<String, dynamic> map in list) {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(map['id'])
          .delete();
    }
  }

  // works? [yes]
  Future deleteNotificationSettingByID(String id) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(id)
        .delete();
  }

  // works? [yes]
  Future updateUserEmail(String newEmail, String userID) async {
    final docUpdate =
        FirebaseFirestore.instance.collection('users').doc(userID);

    docUpdate.update(
      {
        'email': newEmail,
      },
    );
  }

  // works? [yes]
  Future<String> getUserEmailFromUser(String userID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('userID', isEqualTo: userID)
        .get();

    List<Map<String, dynamic>> list = snapshot.docs.map((doc) {
      return doc.data(); // doc.data() is a Map<String, dynamic>
    }).toList();

    String email = list[0]['email'];
    return email;
  }

  // works? [yes]
  Future updateUserPassword(String newPassword, String userID) async {
    final docUpdate =
        FirebaseFirestore.instance.collection('users').doc(userID);

    docUpdate.update(
      {
        'password': newPassword,
      },
    );
  }

  // works? [yes]
  Future<String> getUserPasswordFromUser(String userID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('userID', isEqualTo: userID)
        .get();

    List<Map<String, dynamic>> list = snapshot.docs.map((doc) {
      return doc.data(); // doc.data() is a Map<String, dynamic>
    }).toList();

    String password = list[0]['password'];
    return password;
  }

  // works? [yes]
  Future updateUserFirstName(String newUserFirstName, String userID) async {
    final docUpdate =
        FirebaseFirestore.instance.collection('users').doc(userID);

    docUpdate.update(
      {
        'firstname': newUserFirstName,
      },
    );
  }

  // works? [yes]
  Future<String> getUserFirstNameFromUser(String userID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('userID', isEqualTo: userID)
        .get();

    List<Map<String, dynamic>> list = snapshot.docs.map((doc) {
      return doc.data(); // doc.data() is a Map<String, dynamic>
    }).toList();

    String firstname = list[0]['firstname'];
    return firstname;
  }

  // works? [yes]
  Future updateUserLastName(String newUserLastName, String userID) async {
    final docUpdate =
        FirebaseFirestore.instance.collection('users').doc(userID);

    docUpdate.update(
      {
        'lastname': newUserLastName,
      },
    );
  }

  // works? [yes]
  Future<String> getUserLastNameFromUser(String userID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('userID', isEqualTo: userID)
        .get();

    List<Map<String, dynamic>> list = snapshot.docs.map((doc) {
      return doc.data(); // doc.data() is a Map<String, dynamic>
    }).toList();

    String lastname = list[0]['lastname'];
    return lastname;
  }

  // works? [yes]
  Future<bool> isEmailTaken(String email) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    List<Map<String, dynamic>> list = snapshot.docs.map((doc) {
      return doc.data(); // doc.data() is a Map<String, dynamic>
    }).toList();

    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // works? [yes]
  Future deleteUserAccount(String userID) async {
    await FirebaseFirestore.instance.collection('users').doc(userID).delete();
  }

  // works? [yes]
  Future deleteUserFavoriteItems(String userID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('favorite_items')
        .where('userID', isEqualTo: userID)
        .get();

    List<Map<String, dynamic>> list = snapshot.docs.map((doc) {
      return doc.data(); // doc.data() is a Map<String, dynamic>
    }).toList();

    for (Map<String, dynamic> map in list) {
      FirebaseFirestore.instance
          .collection('favorite_items')
          .doc(map['id'])
          .delete();
    }
  }

  // works? [yes]
  Future deleteUserNotifications(String userID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('notifications')
        .where('userID', isEqualTo: userID)
        .get();

    List<Map<String, dynamic>> list = snapshot.docs.map((doc) {
      return doc.data(); // doc.data() is a Map<String, dynamic>
    }).toList();

    for (Map<String, dynamic> map in list) {
      FirebaseFirestore.instance
          .collection('notifications')
          .doc(map['id'])
          .delete();
    }
  }
}
