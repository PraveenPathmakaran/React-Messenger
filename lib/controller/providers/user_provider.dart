import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User get getUser {
    if (_user == null) {
      return User(
          email: '',
          uid: '',
          photoUrl: '',
          username: '',
          followers: [],
          following: []);
    }

    return _user!;
  }

  final AuthMethods _authMethods = AuthMethods();
  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
