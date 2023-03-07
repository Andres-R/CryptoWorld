import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_world/data/models/crypto_currency_model.dart';

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
  Future<List<Map<String, dynamic>>> getFavoriteItems(String userID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('favorite_items')
        .where('userID', isEqualTo: userID)
        .get();

    List<Map<String, dynamic>> list = snapshot.docs.map((doc) {
      return doc.data(); // doc.data() is a Map<String, dynamic>
    }).toList();
    return list;
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
