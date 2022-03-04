import 'dart:async';

import 'package:flutter/services.dart';

typedef Result = int;

const Result cancelled = -1;
const Result success = 1;
const Result failed = 0;

class FacebookMessengerShare {
  static const MethodChannel _channel =
      MethodChannel('facebook_messenger_share');

  static Future shareToMessenger(
      {required String urlString,
      required Function() onSuccess,
      required Function() onFailed,
      required Function() onCancelled}) async {
    final result =
        await _channel.invokeMethod<Result>('shareToMessenger', urlString);
    if (result == success) {
      onSuccess();
    } else if (result == failed) {
      onFailed();
    } else if (result == cancelled) {
      onCancelled();
    }
  }
}
