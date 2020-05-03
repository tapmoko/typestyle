import UIKit
import SafariServices
import StoreKit

class AboutViewController: UIViewController {

  // MARK: - Instance variables

  let tipMessages = [
    "TypeStyle is ad-free, tracker-free, and free of charge! Instead, I rely on your support to fund its development. Please consider leaving a tip in the Tip Jar.",
    "Thank you so much for tipping! 💛",
    "Another tip?? You're the best!\n❤️🧡💛💚💙💜",
  ]

  lazy var tipLabelView = AboutLabelView(text: tipMessages[0])

  let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
//    scrollView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    return scrollView
  }()

  lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      AboutLabelView(text: "TypeStyle is an app created by me, Eugene Belinski."),
      AboutButtonView(text: "My Website", kind: .link("https://ebelinski.com")),
      tipLabelView,
      AboutButtonView(text: "$1.99 Tip", kind: .tip),
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

  var confettiView: ConfettiView?

  // MARK: - Tipping

  var tipProducts: [SKProduct] = []

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
                                           selector: #selector(handlePurchaseNotification(_:)),
                                           name: .iapHelperPurchaseNotification,
                                           object: nil)

    Products.store.requestProducts{ [weak self] success, tipProducts in
      guard let self = self else { return }
      if success {
        self.tipProducts = tipProducts!
      }
    }
  }

  @objc func handlePurchaseNotification(_ notification: Notification) {
    guard let productID = notification.object as? String else {
      log.error("Could not get productID from purchase notification")
      return
    }
    log.info("Got purchase notification for productID \(productID)")

    confirmTipPurchase()
  }

  func confirmTipPurchase() {
    if tipLabelView.label.text == tipMessages[0] {
      tipLabelView.label.text = tipMessages[1]
    } else if tipLabelView.label.text == tipMessages[1] {
      tipLabelView.label.text = tipMessages[2]
    }

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
    if tipProducts.isEmpty {
      log.error("tipProducts is empty")
      return
    }
    Products.store.buyProduct(tipProducts[0])
  }

}
