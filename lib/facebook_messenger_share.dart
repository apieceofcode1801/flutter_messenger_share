import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

typedef Result = int;

const Result cancelled = -1;
const Result success = 1;
const Result failed = 0;

class CompleteHandler {
  final void Function()? onSuccess;
  final void Function()? onFailed;
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
  Future shareDataImages(
      {required List<Uint8List> data,
      required CompleteHandler completeHandler});

  /// Share list of videos with video's paths
  Future shareVideos(
      {required List<String> paths, required CompleteHandler completeHandler});
}

class FacebookMessengerShare implements IFacebookMessengerShare {
  FacebookMessengerShare._();
  static FacebookMessengerShare get instance {
    return FacebookMessengerShare._();
  }

  static const MethodChannel _channel =
      MethodChannel('facebook_messenger_share');

  @override
  Future shareDataImages(
      {required List<Uint8List> data,
      required CompleteHandler completeHandler}) async {
    final result = await _channel.invokeMethod<Result>('shareDataImages', data);
    _handleResult(result, completeHandler);
  }

  @override
  Future shareImages(
      {required List<String> paths,
      required CompleteHandler completeHandler}) async {
    final result = await _channel.invokeMethod<Result>('shareImages', paths);
    _handleResult(result, completeHandler);
  }

  @override
  Future shareUrl(
      {required String urlString,
      required CompleteHandler completeHandler}) async {
    final result = await _channel.invokeMethod<Result>('shareUrl', urlString);
    _handleResult(result, completeHandler);
  }

  @override
  Future shareVideos(
      {required List<String> paths,
      required CompleteHandler completeHandler}) async {
    final result = await _channel.invokeMethod<Result>('shareVideos', paths);
    _handleResult(result, completeHandler);
  }

  _handleResult(Result? result, CompleteHandler completeHandler) {
    if (result == success && completeHandler.onSuccess != null) {
      completeHandler.onSuccess!();
    } else if (result == failed && completeHandler.onFailed != null) {
      completeHandler.onFailed!();
    } else if (result == cancelled && completeHandler.onCancelled != null) {
      completeHandler.onCancelled!();
    }
  }
}
