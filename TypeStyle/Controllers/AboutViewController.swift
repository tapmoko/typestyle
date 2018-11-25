import UIKit

class AboutViewController: UITableViewController {

  let cells: [UITableViewCell] = [
    AboutLabelTableViewCell(text: "TypeStyle is an app created by Eugene Belinski.")
  ]

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

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cells.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return cells[indexPath.row]
  }

}
