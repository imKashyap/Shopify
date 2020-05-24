import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopify/models/exception.dart';

class Auth extends ChangeNotifier {
  String _token;
  DateTime _expiryTime;
  String _userId;
  Timer autoLogoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiryTime.isAfter(DateTime.now()) &&
        _expiryTime != null)
      return _token;
    else
      return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAb_vczj3u2vx_qLW16rAqZwGIe8vQbgzs';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _expiryTime = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryTime': _expiryTime.toIso8601String()
      });
      prefs.setString('userData', userData);
      autoLogout();
      notifyListeners();
    } catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _expiryTime = null;
    _userId = null;
    if (autoLogoutTimer != null) {
      autoLogoutTimer.cancel();
      autoLogoutTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    if (DateTime.parse(extractedUserData['expiryTime'])
        .isBefore(DateTime.now())) return false;
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryTime = DateTime.parse(extractedUserData['expiryTime']);
    autoLogout();
    notifyListeners();
    return true;
  }

  void autoLogout() {
    if (autoLogoutTimer != null) autoLogoutTimer.cancel();
    int timeToExpiry = _expiryTime.difference(DateTime.now()).inSeconds;
    autoLogoutTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
