import Flutter
import UIKit
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  private static let badgeChannelName = "com.roseholding.crm/badge"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Register for remote notifications (required when proxy is disabled)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    // iOS never clears `aps.badge` by itself — the app has to zero it.
    // Dart calls this on launch and on every resume.
    if let controller = window?.rootViewController as? FlutterViewController {
      let badgeChannel = FlutterMethodChannel(
        name: AppDelegate.badgeChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      badgeChannel.setMethodCallHandler { call, result in
        guard call.method == "clear" else {
          result(FlutterMethodNotImplemented)
          return
        }
        AppDelegate.clearBadge()
        result(nil)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Forward APNs token to Firebase (required because FirebaseAppDelegateProxyEnabled = false)
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // Safety net for the case where the Dart isolate is not yet up (e.g. the app
  // is resumed straight into the splash before `initialize()` has run).
  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    AppDelegate.clearBadge()
  }

  private static func clearBadge() {
    let center = UNUserNotificationCenter.current()
    center.removeAllDeliveredNotifications()
    if #available(iOS 16.0, *) {
      center.setBadgeCount(0)
    } else {
      UIApplication.shared.applicationIconBadgeNumber = 0
    }
  }
}
