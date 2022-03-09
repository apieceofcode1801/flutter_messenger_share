import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class CompleteHandler {
  final void Function()? onSuccess;
  final void Function(String? message)? onFailed;
  final void Function()? onCancelled;

  CompleteHandler({this.onSuccess, this.onFailed, this.onCancelled});
}

abstract class IFacebookMessengerShare {
  /// Share URL with [urlString], URL need to be valid, for example: 'example.com'
  Future shareUrl(
      {required String urlString, required CompleteHandler completeHandler});

  /// Share list of images with image's paths
  Future shareImages(
      {required List<String> paths, required CompleteHandler completeHandler});

  /// Share list of images with list of image data
  Future shareDataImage(
      {required Uint8List data, required CompleteHandler completeHandler});

  /// Share list of videos with video's paths
  Future shareVideo(
      {required Uint8List data, required CompleteHandler completeHandler});
}

class FacebookMessengerShare implements IFacebookMessengerShare {
  FacebookMessengerShare._();
  static FacebookMessengerShare get instance {
    return FacebookMessengerShare._();
  }

  static const MethodChannel _channel =
      MethodChannel('facebook_messenger_share');

  @override
  Future shareDataImage(
      {required Uint8List data,
      required CompleteHandler completeHandler}) async {
    final result = await _channel.invokeMethod('shareDataImage', data);
    _handleResult(result, completeHandler);
  }

  @override
  Future shareImages(
      {required List<String> paths,
      required CompleteHandler completeHandler}) async {
    final result = await _channel.invokeMethod('shareImages', paths);
    _handleResult(result, completeHandler);
  }

  @override
  Future shareUrl(
      {required String urlString,
      required CompleteHandler completeHandler}) async {
    final result = await _channel.invokeMethod('shareUrl', urlString);
    _handleResult(result, completeHandler);
  }

  @override
  Future shareVideo(
      {required Uint8List data,
      required CompleteHandler completeHandler}) async {
    final result = await _channel.invokeMethod('shareVideo', data);
    _handleResult(result, completeHandler);
  }

  _handleResult(dynamic result, CompleteHandler completeHandler) {
    if (result is Map) {
      final shareResult = ShareResult.fromJson(result);
      if (shareResult.code == 1 && completeHandler.onSuccess != null) {
        completeHandler.onSuccess!();
      } else if (shareResult.code == 0 && completeHandler.onFailed != null) {
        completeHandler.onFailed!(shareResult.message);
      } else if (shareResult.code == -1 &&
          completeHandler.onCancelled != null) {
        completeHandler.onCancelled!();
      }
    }
  }
}

class ShareResult {
  final int code;
  final String? message;

  const ShareResult(this.code, this.message);

  factory ShareResult.fromJson(Map json) =>
      ShareResult(json['code'], json['message'].toString());
}
