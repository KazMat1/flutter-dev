import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let googleApiKey = Bundle.main.infoDictionary!["GOOGLE_MAP_API_KEY"] as! String
    GMSServices.provideAPIKey(googleApiKey) // google_maps_flutterで利用する場合
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
