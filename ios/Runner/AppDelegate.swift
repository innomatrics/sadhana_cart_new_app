import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase is initialized in Flutter (MainHelper.inits())
    // No need to initialize here to avoid conflicts

    // Add safe plugin registration with error handling
    DispatchQueue.main.async {
      GeneratedPluginRegistrant.register(with: self)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}