import 'package:flutter/widgets.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuth.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuthNotifier.dart';

class StreamAuthScope extends InheritedNotifier<StreamAuthNotifier> {
  // final StreamAuth streamAuth;
  // final StreamAuthNotifier authNotifier;
  //
  // StreamAuthScope({
  //   required this.streamAuth,
  //   required this.authNotifier,
  //   required Widget child,
  // }) : super(child: child);
//   StreamAuthScope({
//     super.key,
//     required super.child,
// }): super(
//     notifier: StreamAuthNotifier();
//   )
//
//   static StreamAuthScope of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<StreamAuthScope>()!;
//   }
//
//   @override
//   bool updateShouldNotify(StreamAuthScope oldWidget) {
//     return authNotifier != oldWidget.authNotifier;

  StreamAuthScope({
    super.key,
    required super.child,
  }) : super(
          notifier: StreamAuthNotifier(),
        );

  /// Gets the [StreamAuth].
  static StreamAuth of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<StreamAuthScope>()!
        .notifier!
        .streamAuth;
  }

}
