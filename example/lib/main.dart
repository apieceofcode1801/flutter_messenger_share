import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:facebook_messenger_share/facebook_messenger_share.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? doneWithoutFailure;

  @override
  void initState() {
    super.initState();
  }

  Future<void> shareToFacebook() async {
    try {
      await FacebookMessengerShare.instance.shareUrl(
          urlString: 'https://facebook.com',
          completeHandler: CompleteHandler(
            onSuccess: () {
              setState(() {
                doneWithoutFailure = true;
              });
            },
            onCancelled: () {
              setState(() {
                doneWithoutFailure = true;
              });
            },
            onFailed: () {
              setState(() {
                doneWithoutFailure = false;
              });
            },
          ));
    } on PlatformException {
      setState(() {
        doneWithoutFailure = false;
      });
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: doneWithoutFailure == null
              ? Container()
              : Text(
                  'Share to Messenger ${!doneWithoutFailure! ? 'Failed' : 'Done'}',
                ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.share),
          onPressed: () => shareToFacebook(),
        ),
      ),
    );
  }
}
