import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mojatablica/Models/errors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isToken {
    bool tokenTest = getToken != null;
    return tokenTest;
  }

  String? get getToken {
    if ((_expiryDate != null && _expiryDate!.isAfter(DateTime.now())) ||
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get getUserId {
    if ((_expiryDate != null && _expiryDate!.isAfter(DateTime.now())) ||
        _token != null) {
      return _userId;
    }
    return null;
  }

  Future<void> _authentication(String email, String password, Uri url) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw httpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn']) - 1));
      _timingLogOut();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('autenthicationData', userData);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAtIIA89ATpfUYZypj-g0zr0AhguT-V6S8');
    return _authentication(email, password, url);
  }

  Future<void> signin(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAtIIA89ATpfUYZypj-g0zr0AhguT-V6S8');
    return _authentication(email, password, url);
  }

  Future<bool> checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('autenthicationData')) {
      final userData = prefs.getString('autenthicationData');
      final extractedData = json.decode(userData!) as Map<String, dynamic>;
      final expiryDate = DateTime.parse(extractedData['expiryDate']);

      if (expiryDate.isBefore(DateTime.now())) return false;

      _token = extractedData['token'];
      _userId = extractedData['userId'];
      _expiryDate = expiryDate;
      notifyListeners();
      _timingLogOut();
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _timingLogOut() {
    if (_authTimer != null) _authTimer?.cancel();

    Duration durationToLogout =
        Duration(seconds: _expiryDate!.difference(DateTime.now()).inSeconds);
    _authTimer = Timer(durationToLogout, logout);
  }
}
