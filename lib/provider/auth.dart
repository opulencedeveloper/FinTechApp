import "dart:convert";
import "dart:async";

import "package:flutter/widgets.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  String? myUserName;

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBa7nU_8G0l-MJsUaNQDEsaX9pqeOsBln4");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      final responseData = json.decode(response.body);

      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }

      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData["expiresIn"],
          ),
        ),
      );
      // if (urlSegment == 'signUp') {
      //   await FirebaseFirestore.instance.collection('users').doc(responseData["localId"]).set({
      //     'username': usename,
      //     'email': email,
      //   });
      // }
      _autoLogout();
      final prefs = await SharedPreferences.getInstance();

      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );

      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }

    notifyListeners();
    // print(json.decode(response.body));
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> createUsername(String useName) async {
    final url = Uri.parse("https://fin-tech-1878e-default-rtdb.firebaseio.com/username/$_userId.json?auth=$token"); //

    final response = await http.post(
      url,
      body: json.encode({
        "user": useName,
      }),
    );
    print(json.decode(response.body));
    myUserName = useName;
    //logout();
  }

  String? get userNameGet {
    return myUserName;
  }

  Future<void> fetchAndSetUserName() async {
    final url = Uri.parse("https://fin-tech-1878e-default-rtdb.firebaseio.com/username/$_userId.json?auth=$token"); //?auth=$token
    final response = await http.get(url);
    final extractedUserName = json.decode(response.body);
    print(json.decode(response.body));
    if (extractedUserName == null || extractedUserName.isEmpty) {
      print("fetch and set username is null");
      return;
    }
    String? fetchedUsername;
    extractedUserName.forEach((prodIId, prodDData) {
      print('prodDData["user"]');
      print(prodDData["user"].toString());
      fetchedUsername = prodDData["user"];
    });
    myUserName = fetchedUsername;
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    final expiryDate = DateTime.parse(extractedUserData['expiryDate'] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'].toString();

    _userId = extractedUserData['userId'].toString();

    _expiryDate = expiryDate;

    notifyListeners();

    _autoLogout();

    return true;
  }

  Future<void> logout() async {
    _token = "";
    _userId = "";
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    //prefs.remove('checker');
    prefs.clear();

    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
