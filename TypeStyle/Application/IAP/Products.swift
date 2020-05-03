import Foundation
import StoreKit

struct Products {

  static let store = IAPHelper(productIdentifiers: Products.productIdentifiers)
  static let generousTipIAP = "\(bundleID).GenerousTip"

  static var tipProducts: [SKProduct] = []

  private static let productIdentifiers: Set<ProductIdentifier> = [
    Products.generousTipIAP
  ]

}
