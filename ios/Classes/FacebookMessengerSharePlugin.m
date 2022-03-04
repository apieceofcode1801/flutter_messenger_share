#import "FacebookMessengerSharePlugin.h"
#if __has_include(<facebook_messenger_share/facebook_messenger_share-Swift.h>)
#import <facebook_messenger_share/facebook_messenger_share-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "facebook_messenger_share-Swift.h"
#endif

@implementation FacebookMessengerSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFacebookMessengerSharePlugin registerWithRegistrar:registrar];
}
@end
