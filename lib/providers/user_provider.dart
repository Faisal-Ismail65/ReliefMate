import 'package:flutter/foundation.dart';
import 'package:reliefmate/models/auth_user.dart';
import 'package:reliefmate/services/auth/auth_methods.dart';

class UserProvider with ChangeNotifier {
  AuthUser? _user;
  final AuthMethods _authMethods = AuthMethods();
  AuthUser get getUser => _user!;

  Future<void> refreshUser() async {
    AuthUser user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
