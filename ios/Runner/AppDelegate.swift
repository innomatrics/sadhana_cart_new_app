import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Add safe plugin registration with error handling
    DispatchQueue.main.async {
        GeneratedPluginRegistrant.register(with: self)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}