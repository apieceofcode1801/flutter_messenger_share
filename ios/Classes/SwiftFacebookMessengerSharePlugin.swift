import Flutter
import UIKit
import FBSDKShareKit

public class SwiftFacebookMessengerSharePlugin: NSObject, FlutterPlugin {
    
    var result: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "facebook_messenger_share", binaryMessenger: registrar.messenger())
        let instance = SwiftFacebookMessengerSharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        guard call.method == "shareToMessenger", let urlString = call.arguments as? String else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        shareToMessenger(urlString: urlString)
    }
    
    func shareToMessenger(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.result?(0)
            return
        }
        
        let content = ShareLinkContent()
        content.contentURL = url
        
        let dialog = MessageDialog(content: content, delegate: self)
        
        do {
            try dialog.validate()
        } catch {
            print(error)
            self.result?(0)
        }
        
        dialog.show()
        
    }
}

extension SwiftFacebookMessengerSharePlugin: SharingDelegate {
    
    public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        self.result?(1)
    }
    
    public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        self.result?(0)
    }
    
    public func sharerDidCancel(_ sharer: Sharing) {
        self.result?(-1)
    }
}
