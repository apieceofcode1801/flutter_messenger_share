import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:facebook_messenger_share/facebook_messenger_share.dart';

void main() {
  const MethodChannel channel = MethodChannel('facebook_messenger_share');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return 1;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(
        await FacebookMessengerShare.instance.shareUrl(
            urlString: 'urlString', completeHandler: CompleteHandler()),
        1);
  });
}
