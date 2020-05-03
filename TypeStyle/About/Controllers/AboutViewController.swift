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

  lazy var tipLabelCell = AboutLabelTableViewCell(text: tipMessages[0])

  lazy var cells: [UITableViewCell] = [
    AboutLabelTableViewCell(text: "TypeStyle is an app created by me, Eugene Belinski."),
    AboutButtonTableViewCell(text: "My Website", kind: .link("https://ebelinski.com")),
    tipLabelCell,
    AboutButtonTableViewCell(text: "$1.99 Tip", kind: .tip),
    AboutLabelTableViewCell(text: "TypeStyle is open source! It is written in Swift 5, and released under the GNU-GPL 3.0 license."),
    AboutButtonTableViewCell(text: "View Source", kind: .link("https://github.com/ebelinski/typestyle-ios")),
    AboutLabelTableViewCell(text: "The TypeStyle privacy policy is available here:"),
    AboutButtonTableViewCell(text: "Privacy Policy", kind: .link("https://typestyle.app/privacy-policy"))
  ]

  var confettiView: ConfettiView?

  let tableView = UITableView()

  // MARK: - Tipping

  var tipProducts: [SKProduct] = []

  // MARK: - Methods

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .appBackground

    // Set up table view

    tableView.backgroundColor = .appBackground
    tableView.separatorStyle = .none
    tableView.dataSource = self
    tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
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
    if tipLabelCell.label.text == tipMessages[0] {
      tipLabelCell.label.text = tipMessages[1]
    } else if tipLabelCell.label.text == tipMessages[1] {
      tipLabelCell.label.text = tipMessages[2]
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

// MARK: Table view data source

extension AboutViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cells.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = cells[indexPath.row]
    (cell as? AboutButtonTableViewCell)?.delegate = self
    return cell
  }
}

// MARK: URL opening

extension AboutViewController: AboutButtonTableViewCellDelegate {

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
