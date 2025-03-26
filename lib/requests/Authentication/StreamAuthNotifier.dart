import 'package:flutter/material.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuth.dart';

class StreamAuthNotifier extends ChangeNotifier{

  StreamAuthNotifier() : streamAuth = StreamAuth() {
    streamAuth.onCurrentUserChanged.listen((String? string) {
      notifyListeners();
    });
  }

  /// The stream auth client.
  final StreamAuth streamAuth;

  //bool get isSignedIn => streamAuth.currentUser != null;
}