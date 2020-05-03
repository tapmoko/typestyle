import StoreKit

typealias ProductIdentifier = String
typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
  static let iapHelperPurchaseNotification = Notification.Name("iapHelperPurchaseNotification")
}

class IAPHelper: NSObject  {

  private let productIdentifiers: Set<ProductIdentifier>
  private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
  private var productsRequest: SKProductsRequest?
  private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?

  init(productIdentifiers: Set<ProductIdentifier>) {
    self.productIdentifiers = productIdentifiers
    
    for productIdentifier in self.productIdentifiers {
      let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
      if purchased {
        purchasedProductIdentifiers.insert(productIdentifier)
        log.info("Previously purchased: \(productIdentifier)")
      } else {
        log.info("Not purchased: \(productIdentifier)")
      }
    }
    super.init()

    SKPaymentQueue.default().add(self)
  }
}

// MARK: - StoreKit API

extension IAPHelper {

  func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler

    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest?.delegate = self
    productsRequest?.start()
  }

  func buyProduct(_ product: SKProduct) {
    log.info("Buying: \(product.productIdentifier)")
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {

  func productsRequest(_ request: SKProductsRequest,
                       didReceive response: SKProductsResponse) {
    log.info("Loaded list of products")
    let products = response.products
    productsRequestCompletionHandler?(true, products)
    clearRequestAndHandler()

    for product in products {
      log.info("Found product: \(product.productIdentifier) \(product.localizedTitle) \(product.price.floatValue)")
    }
  }

  func request(_ request: SKRequest, didFailWithError error: Error) {
    log.error("Failed to load list of products. Error: \(error)")
    productsRequestCompletionHandler?(false, nil)
    clearRequestAndHandler()
  }

  private func clearRequestAndHandler() {
    productsRequest = nil
    productsRequestCompletionHandler = nil
  }
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {

  func paymentQueue(_ queue: SKPaymentQueue,
                    updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch (transaction.transactionState) {
      case .purchased:
        complete(transaction: transaction)
        break
      case .failed:
        fail(transaction: transaction)
        break
      case .deferred: break
      case .purchasing: break
      default: break
      }
    }
  }

  private func complete(transaction: SKPaymentTransaction) {
    log.info("complete: \(transaction)")
    deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }

  private func fail(transaction: SKPaymentTransaction) {
    log.error("fail: \(transaction)")
    if let transactionError = transaction.error as NSError?,
      let localizedDescription = transaction.error?.localizedDescription,
      transactionError.code != SKError.paymentCancelled.rawValue {
      log.error("Transaction Error: \(localizedDescription)")
    }

    SKPaymentQueue.default().finishTransaction(transaction)
  }

  private func deliverPurchaseNotificationFor(identifier: ProductIdentifier?) {
    guard let identifier = identifier else { return }

    purchasedProductIdentifiers.insert(identifier)
    UserDefaults.standard.set(true, forKey: identifier)
    NotificationCenter.default.post(name: .iapHelperPurchaseNotification, object: identifier)
  }
}
