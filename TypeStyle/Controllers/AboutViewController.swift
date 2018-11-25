import UIKit

class AboutViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .appBackground

    // Set navigation bar colors and style
    navigationController?.navigationBar.barTintColor = .appDarkBackground
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.tintColor = .appText
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.prefersLargeTitles = true

    // Set navigation bar contents

    navigationItem.title = "About TypeStyle"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                        target: self,
                                                        action: #selector(didTapDoneButton))

    // Set up table view

    tableView.separatorStyle = .none
  }

  @objc func didTapDoneButton() {
    dismiss(animated: true, completion: nil)
  }

}
