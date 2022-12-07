import 'dart:convert';
import "dart:async";

import "package:flutter/widgets.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String name;
  String firstName;
  String imageUrl;
  double amount;
  String date;
  String assetUrl;

  User({
    required this.name,
    required this.firstName,
    required this.imageUrl,
    required this.amount,
    required this.date,
    this.assetUrl = 'assets/images/ssearch.png',
  });
}

class Users with ChangeNotifier {
  List<User> _user = [
    // User(
    //   name: 'Victor Opulence',
    //   firstName: 'Victor',
    //   assetUrl: 'assets/images/ssearch.png',
    //   imageUrl: 'assets/images/profile.png',
    //   amount: 800,
    //   date: '02-02-2022 7:00 AM',
    // ),
    // User(
    //   name: 'Victor Opulence',
    //   firstName: 'Victor',
    //   imageUrl: 'assets/images/d1.png',
    //   amount: 800,
    //   date: '02-02-2022 7:00 AM',
    // ),
    // User(
    //   name: 'Kudos Lucky',
    //   firstName: 'Kudos',
    //   imageUrl: 'assets/images/d2.png',
    //   amount: 200,
    //   date: '02-02-2022 9:00 AM',
    // ),
    // User(
    //   name: 'Philip Emeka',
    //   firstName: 'Philip',
    //   imageUrl: 'assets/images/d3.png',
    //   amount: 300,
    //   date: '02-02-2022 10:05 AM',
    // ),
    // User(
    //   name: 'John Christopher',
    //   firstName: 'John',
    //   imageUrl: 'assets/images/d4.png',
    //   amount: 200,
    //   date: '02-02-2022 7:00 AM',
    // ),
  ];

  final String authToken;
  Users(this.authToken, this._user);
  List<User> get user {
    return [
      ..._user
    ];
  }

  Future<void> fetchAndSetUsers() async {
    final filterString = {
      "auth": authToken
    };
    //var url = Uri.parse("https://fin-tech-1878e-default-rtdb.firebaseio.com/users.json?auth=$authToken");
    var url = Uri.https('fin-tech-1878e-default-rtdb.firebaseio.com', '/users.json', filterString);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<User> loadedUsers = [];
      extractedData.forEach((prodId, userData) {
        loadedUsers.add(User(
          assetUrl: userData['assetUrl'].toString(),
          name: userData['name'].toString(),
          firstName: userData['firstName'].toString(),
          imageUrl: userData['imageUrl'].toString(),
          amount: userData['amount'].toDouble(),
          date: userData['date'].toString(),
        ));
      });
      _user = loadedUsers;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

  Future<void> fetchAndSetP() async {
    // final filterString = {
    //   "auth": authToken
    // };
    //var url = Uri.https("my-shop-app-5a251-default-rtdb.firebaseio.com", "/products.json", filterString);
    var url = Uri.https('fin-tech-1878e-default-rtdb.firebaseio.com', '/users.json');
    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null || extractedData.isEmpty) {
        print("fetch and set  foods is null");
        return;
      }
      final List<User> loadedUsers = [];
      extractedData.forEach((userId, userData) {
        loadedUsers.add(User(
          // userId: userId,
          assetUrl: userData['assetUrl'],
          name: userData['name'],
          firstName: userData['firstName'],
          imageUrl: userData['imageUrl'],
          amount: userData['amount'],
          date: userData['date'],
        ));
      });
      _user = loadedUsers;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  int myTheme = 0;

  int get selectedTheme {
    return myTheme;
  }

  void setTheme(int setTheme) {
    myTheme = setTheme;
    notifyListeners();
  }
}
