import 'package:flutter/foundation.dart';

class PostsNotifier extends ChangeNotifier {
  bool _shouldRefresh = false;

  bool get shouldRefresh => _shouldRefresh;

  void markForRefresh() {
    _shouldRefresh = true;
    notifyListeners();
  }

  void reset() {
    _shouldRefresh = false;
  }
}