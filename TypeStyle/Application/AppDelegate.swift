import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  var didAutomaticallyShowKeyboardOnce = false

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = MainTabBarController()
    window?.makeKeyAndVisible()

    Products.store.requestProducts { success, tipProducts in
      if success {
        if let tipProducts = tipProducts {
          Products.tipProducts = tipProducts
        }
      }
    }

    return true
  }

}
