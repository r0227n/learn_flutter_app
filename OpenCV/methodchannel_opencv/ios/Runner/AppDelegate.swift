import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let methodChannel = FlutterMethodChannel(name: "samples.flutter.dev/image",
                                             binaryMessenger: controller.binaryMessenger)
      
      methodChannel.setMethodCallHandler(
          {
              (call: FlutterMethodCall, result: FlutterResult) -> Void in
              
              guard call.method == "getBase64" else {
                  result(FlutterMethodNotImplemented)
                  return
              }
              
              let parameters = call.arguments as! String
              // String(Base64) -> Data
              let encodedBase64 = Data(base64Encoded: parameters)
              
              // Data -> UIImage
              let convert = UIImage(data: encodedBase64!)
              let image = OpenCVManager.gray(convert)

              // UIImage -> (JPEG)Data
              let jpegData = image!.jpegData(compressionQuality: 1)
              // Data -> String(Base64)
              let base64 = jpegData!.base64EncodedString()
              result(base64)

//              result(base64 + "," + code + "," + angle)
          }
      )
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
