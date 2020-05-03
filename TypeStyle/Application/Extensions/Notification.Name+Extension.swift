import Foundation

extension Notification.Name {

  struct IAP {

    static let purchaseSuccess = Notification.Name("iap.purchaseSuccess")
    static let purchaseCancelled = Notification.Name("iap.purchaseCancelled")
    static let purchaseFailed = Notification.Name("iap.purchaseFailed")

  }

}
