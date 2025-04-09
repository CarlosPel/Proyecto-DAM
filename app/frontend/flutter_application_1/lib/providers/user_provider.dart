import 'package:flutter/material.dart';
import 'package:flutter_application_1/clases/user_profile.dart';

class UserProvider with ChangeNotifier {
  UserProfile? user;

  void setUser(UserProfile newUser) {
    user = newUser;
    notifyListeners();
  }
}