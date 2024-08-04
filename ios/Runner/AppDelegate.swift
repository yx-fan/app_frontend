// import Flutter
// import UIKit
// import GoogleMaps

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GMSServices.provideAPIKey("AIzaSyDeIHKvtk2a27SAiBvItkR61VQHNb_Qw60")
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

import Flutter
import UIKit
import GoogleMaps
import AVFoundation
import Photos

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDeIHKvtk2a27SAiBvItkR61VQHNb_Qw60")
    GeneratedPluginRegistrant.register(with: self)
    
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let cameraChannel = FlutterMethodChannel(name: "flutter.native/helper", binaryMessenger: controller.binaryMessenger)
    
    cameraChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else { return }
      if call.method == "checkCameraPermission" {
        self.checkCameraPermission(result: result)
      } else if call.method == "requestCameraPermission" {
        self.requestCameraPermission(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func checkCameraPermission(result: FlutterResult) {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    switch status {
    case .authorized:
      result("granted")
    case .denied, .restricted:
      result("denied")
    case .notDetermined:
      result("notDetermined")
    @unknown default:
      result("unknown")
    }
  }
  
  private func requestCameraPermission(result: @escaping FlutterResult) {
    AVCaptureDevice.requestAccess(for: .video) { granted in
      DispatchQueue.main.async {
        if granted {
          result("granted")
        } else {
          result("denied")
        }
      }
    }
  }
}
