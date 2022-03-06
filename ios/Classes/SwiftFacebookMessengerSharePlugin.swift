import Flutter
import UIKit
import FBSDKShareKit
import FBSDKCoreKit

public class SwiftFacebookMessengerSharePlugin: NSObject, FlutterPlugin {
    var result: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        ApplicationDelegate.initialize()
        let channel = FlutterMethodChannel(name: "facebook_messenger_share", binaryMessenger: registrar.messenger())
        let instance = SwiftFacebookMessengerSharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        let method = call.method
        
        if method == "shareUrl", let urlString = call.arguments as? String {
            shareUrl(urlString: urlString)
        } else if method == "shareImages" {
            
        } else if method == "shareDataImages" {
            
        } else if method == "shareVideos" {
            
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func shareUrl(urlString: String) {
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
    
    /// START ALLOW HANDLE NATIVE FACEBOOK APP
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        var options = [UIApplication.LaunchOptionsKey: Any]()
        for (k, value) in launchOptions {
            let key = k as! UIApplication.LaunchOptionsKey
            options[key] = value
        }
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: options)
        return true
    }
    
    public func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        let processed = ApplicationDelegate.shared.application(
            app, open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return processed;
    }
    /// END ALLOW HANDLE NATIVE FACEBOOK APP
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
