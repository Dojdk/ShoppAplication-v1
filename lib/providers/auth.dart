import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

import '../models/exception.dart';

class Auth with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime.now();
  String _userId = '';
  Timer? _authTimer;

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expiryDate.isAfter(DateTime.now()) && _token != '') {
      return _token;
    }
    return '';
  }

  Future<void> authenticate(String mail, String password, String part) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$part?key=AIzaSyABat6AMrbjR2EWJgSd4bL51wsQIoT83I0');

    try {
      final response = await http.post(url,
          body: jsonEncode({
            'email': mail,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      // final prefs = await SharedPreferences.getInstance();
      // final userData = jsonEncode({
      //   'token': _token,
      //   'userId': _userId,
      //   'expiryDate': _expiryDate.toIso8601String()
      // });
      // prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future signUp(String mail, String password) {
    return authenticate(mail, password, 'signUp');
  }

  Future logIn(String mail, String password) {
    return authenticate(mail, password, 'signInWithPassword');
  }

  Future<void> logout () async{
    _token = '';
    _userId = '';
    _expiryDate = DateTime.now();
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    // final prefs = await SharedPreferences.getInstance();
    // prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  // Future<bool> tryautologin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userData')) {
  //     return false;
  //   }
  //   final extractedUserData =
  //       jsonDecode(prefs.getString('userData')!) as Map<String, String>;
  //   final expiryDate = DateTime.parse(
  //       extractedUserData['expiryDate'] ?? DateTime.now().toIso8601String());
  //   if (expiryDate.isAfter(DateTime.now())) {
  //     return false;
  //   }
  //   _token = extractedUserData['token']!;
  //   _userId = extractedUserData['userId']!;
  //   _expiryDate = expiryDate;
  //   notifyListeners();
  //   _autoLogout();
  //   return true;
  // }
}
