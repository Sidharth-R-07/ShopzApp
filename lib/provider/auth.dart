import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Exception/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userId;
  Timer? _authTimer;

  static const sharedKey = 'SHARED_PREFERNCES_KEY';
  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }

    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> signUp(String email, String password) async {
    print('Signup succesfulyy');
    return _authenticate(email, password, 'signUp');
    //
  }

  Future<void> signIn(String email, String password) async {
    print('Login succesfulyy');
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com//v1/accounts:$urlSegment?key=AIzaSyArCiobaZ0cAStovJLhV1iclyjV4kuOT3w';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpExceptions(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expireDate': _expireDate!.toIso8601String(),
      });

      await prefs.setString(sharedKey, userData);
    } catch (error) {
      rethrow;
    }

    // print(json.decode(response.body.toString()));
  }

  Future<String> forgotPassword(String email) async {
    String _result = 'Something went wrong.try again!';

  const url =
      'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyArCiobaZ0cAStovJLhV1iclyjV4kuOT3w';
  final body = jsonEncode({
    'requestType': 'PASSWORD_RESET',
    'email': email,
  });

  final response = await http.post(Uri.parse(url), body: body);
  if (response.statusCode == 200) {
   _result= 'Password reset email sent';
  } else {
    _result='Failed to send password reset email';
  }
    return _result;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(sharedKey)) {
      return false;
    }

    final extractedData =
        json.decode(prefs.getString(sharedKey)!) as Map<String, dynamic>;

    final expireDate = DateTime.parse(extractedData['expireDate']);
    if (expireDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expireDate = expireDate;
    notifyListeners();
    return true;
  }

  Future<void> logoutUser() async {
    _token = null;
    _userId = null;
    _expireDate = null;

    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
    print('Logout Succesfully');
  }

  void _autoLogout() async {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    final timeToExpire = _expireDate!.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(Duration(seconds: timeToExpire), logoutUser);

    _authTimer!.cancel();
  }
}
