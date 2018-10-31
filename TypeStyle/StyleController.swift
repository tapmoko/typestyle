import UIKit

class StyleController: UITableViewController {

  let input = "Hello World"

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.backgroundColor = .appBackground
  }

}

// MARK: UITableView Data Source
extension StyleController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return StyleManager.shared.styles.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()

    cell.textLabel?.text = StyleManager.shared.styledText(forText: input, rowIndex: indexPath.row)
    cell.textLabel?.textColor = .appText
    cell.backgroundColor = .appBackground

    return cell
  }

}
