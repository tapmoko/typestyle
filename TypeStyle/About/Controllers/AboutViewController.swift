import UIKit
import SafariServices
import StoreKit

class AboutViewController: UIViewController {

  // MARK: - Static variables

  static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .currency
    return formatter
  }()

  // MARK: - Instance variables

  var confettiView: ConfettiView?

  let loadingView = LoadingView()

  let tipMessages = [
    "TypeStyle is ad-free, tracker-free, and free of charge! Instead, I rely on your support to fund its development. Please consider leaving a tip in the Tip Jar.",
    "Thank you so much for tipping! 💛",
    "Another tip?? You're the best!\n❤️🧡💛💚💙💜",
    "You are the reason there are no ads or trackers on this app. 😎",
    "Maybe some more confetti? 🤔",
    "Ok maybe a lot more confetti. 😄",
    "At this point we'll just keep increasing the confetti. 😛 Thanks again! 🥰",
  ]

  lazy var tipLabelView = AboutLabelView(text: tipMessages[0])
  lazy var tipButtonView = AboutButtonView(text: "Tip", kind: .tip)

  let scrollView = UIScrollView()

  lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      AboutLabelView(text: "TypeStyle is an app created by me, Eugene Belinski."),
      AboutButtonView(text: "My Website", kind: .link("https://ebelinski.com")),
      tipLabelView,
      tipButtonView,
      AboutLabelView(text: "TypeStyle is open source! It is written in Swift 5, and released under the GNU-GPL 3.0 license."),
      AboutButtonView(text: "View Source", kind: .link("https://github.com/ebelinski/typestyle-ios")),
      AboutLabelView(text: "The TypeStyle privacy policy is available here:"),
      AboutButtonView(text: "Privacy Policy", kind: .link("https://typestyle.app/privacy-policy"))
    ])

    stackView.alignment = .fill
    stackView.axis = .vertical
    stackView.spacing = 0
    stackView.subviews.forEach { ($0 as? AboutButtonView)?.delegate = self }

    return stackView
  }()

  // MARK: - Methods

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .appBackground

    // Set up scroll view

    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }

    // Set up stack

    stackView.backgroundColor = .appBackground
    scrollView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.edges.equalTo(scrollView)
      make.width.equalTo(view.safeAreaLayoutGuide)
    }

    // Tip
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handlePurchaseSuccess(_:)),
                                           name: Notification.Name.IAP.purchaseSuccess,
                                           object: nil)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handlePurchaseCancelled(_:)),
                                           name: Notification.Name.IAP.purchaseCancelled,
                                           object: nil)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handlePurchaseFailure(_:)),
                                           name: Notification.Name.IAP.purchaseFailed,
                                           object: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard let product = Products.tipProducts.first else {
      removeTipButton()
      return
    }
    AboutViewController.priceFormatter.locale = product.priceLocale
    guard let price = AboutViewController.priceFormatter.string(from: product.price) else {
      removeTipButton()
      return
    }

    tipButtonView.set(text: "\(price) Tip")
  }

  func removeTipButton() {
    tipLabelView.removeFromSuperview()
    tipButtonView.removeFromSuperview()
  }

  @objc func handlePurchaseSuccess(_ notification: Notification) {
    guard let productID = notification.object as? String else {
      log.error("Could not get productID from purchase notification")
      return
    }
    log.info("Got purchase notification for productID \(productID)")

    confirmTipPurchase()
  }

  @objc func handlePurchaseCancelled(_ notification: Notification) {
    stopLoadingView()
  }

  @objc func handlePurchaseFailure(_ notification: Notification) {
    stopLoadingView()
    alert(errorMessage: "An unknown error occurred. Please try again later.")
  }

  private func confirmTipPurchase() {
    stopLoadingView()
    initializeConfettiView()

    let oldMessageIndex = tipMessages.firstIndex(of: tipLabelView.label.text ?? "") ?? 0
    let newMessageIndex = oldMessageIndex + 1

    if tipMessages.count - 1 >= newMessageIndex {
      tipLabelView.label.text = tipMessages[newMessageIndex]
    }

    if newMessageIndex >= 4 {
      confettiView?.increase()
    }
  }

  private func initializeConfettiView() {
    guard confettiView == nil else { return }

    confettiView = ConfettiView()
    confettiView?.alpha = 0
    confettiView?.isUserInteractionEnabled = false

    view.addSubview(confettiView!)
    confettiView?.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    confettiView?.start()

    UIView.animate(withDuration: 0.3, animations: {
      self.confettiView?.alpha = 1
    }, completion: nil)
  }

  private func startLoadingView() {
    loadingView.start()

    view.addSubview(loadingView)

    loadingView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    loadingView.start()
  }

  private func stopLoadingView() {
    loadingView.stop()
    loadingView.removeFromSuperview()
  }

  func alert(errorMessage: String = "An error occurred. Please try again later.") {
    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true)
  }

}

// MARK: URL opening

extension AboutViewController: AboutButtonViewDelegate {

  func open(link: String) {
    guard let url = URL(string: link) else { return }
    let svc = SFSafariViewController(url: url)
    svc.preferredBarTintColor = .appBackground
    svc.preferredControlTintColor = .appText
    present(svc, animated: true, completion: nil)
  }

  func openTip() {
    guard let product = Products.tipProducts.first else {
      log.error("tipProducts is empty")
      return
    }

    startLoadingView()
    Products.store.buyProduct(product)
  }

}
