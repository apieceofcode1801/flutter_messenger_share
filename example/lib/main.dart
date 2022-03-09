import 'package:flutter/material.dart';
import 'package:facebook_messenger_share/facebook_messenger_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _textController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _completeHandler = CompleteHandler(
    onSuccess: () {
      Fluttertoast.showToast(msg: 'Share succeeded');
    },
    onCancelled: () {
      Fluttertoast.showToast(msg: 'User cancelled sharing');
    },
    onFailed: (message) =>
        Fluttertoast.showToast(msg: message ?? 'Something went wrong'),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  _shareImages();
                },
                child: const Text('Share Images From Library'),
              ),
              TextButton(
                onPressed: () {
                  _shareACapturedImage();
                },
                child: const Text('Share a Captured Image'),
              ),
              TextButton(
                onPressed: () {
                  _shareAVideo();
                },
                child: const Text('Share a Video'),
              ),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(hintText: 'Enter URL'),
              ),
              TextButton(
                onPressed: () {
                  _shareUrl(urlStr: _textController.text);
                },
                child: const Text('Share URL'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareImages() {
    _share(() async {
      final images = await _imagePicker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        FacebookMessengerShare.instance.shareImages(
          paths: images.map((e) => e.path).toList(),
          completeHandler: _completeHandler,
        );
      }
    });
  }

  void _shareACapturedImage() {
    _share(() async {
      final image = await _imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        FacebookMessengerShare.instance.shareDataImage(
            data: await image.readAsBytes(), completeHandler: _completeHandler);
      }
    });
  }

  void _shareAVideo() {
    _share(() async {
      final video = await _imagePicker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        FacebookMessengerShare.instance.shareVideo(
            data: await video.readAsBytes(), completeHandler: _completeHandler);
      }
    });
  }

  void _shareUrl({required String urlStr}) {
    _share(() {
      FacebookMessengerShare.instance
          .shareUrl(urlString: urlStr, completeHandler: _completeHandler);
    });
  }

  _share(Function() share) {
    try {
      share();
    } catch (_) {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }
}
