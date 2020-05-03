import Foundation

struct Products {

  static let store = IAPHelper(productIdentifiers: Products.productIdentifiers)
  static let generousTipIAP = "\(bundleID).GenerousTip"

  private static let productIdentifiers: Set<ProductIdentifier> = [
    Products.generousTipIAP
  ]

}
