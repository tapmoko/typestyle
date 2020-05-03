import UIKit
import SafariServices

class AboutViewController: UITableViewController {

  let cells: [UITableViewCell] = [
    AboutLabelTableViewCell(text: "TypeStyle is an app created by me, Eugene Belinski."),
    AboutButtonTableViewCell(text: "My Website", kind: .link("https://ebelinski.com")),
    AboutLabelTableViewCell(text: "TypeStyle is free, add-free, and tracker-free! Instead, I rely on your support to fund its development. Please consider leaving a tip in the Tip Jar."),
    AboutButtonTableViewCell(text: "$1.99 Tip", kind: .tip),
    AboutLabelTableViewCell(text: "TypeStyle is open source! It is written in Swift 5, and released under the GNU-GPL 3.0 license."),
    AboutButtonTableViewCell(text: "View Source", kind: .link("https://github.com/ebelinski/typestyle-ios")),
    AboutLabelTableViewCell(text: "The TypeStyle privacy policy is available here:"),
    AboutButtonTableViewCell(text: "Privacy Policy", kind: .link("https://typestyle.app/privacy-policy"))
  ]

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .appBackground

    // Set up table view

    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
  }

}

// MARK: Table view data source

extension AboutViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cells.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

}
