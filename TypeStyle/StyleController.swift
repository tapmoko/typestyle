import UIKit
import SnapKit

class StyleController: UIViewController {

  let tableView = UITableView()
  let inputField = UITextField()

  let input = "Hello World"

  override func viewDidLoad() {
    super.viewDidLoad()

    setUpInputField()
    setUpTableView()
  }

  func setUpInputField() {
    view.addSubview(inputField)

    inputField.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
    }
  }

  func setUpTableView() {
    tableView.dataSource = self
    tableView.backgroundColor = .appBackground

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.top.equalTo(inputField.snp.bottom)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

}

extension StyleController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return StyleManager.shared.styles.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()

    cell.textLabel?.text = StyleManager.shared.styledText(forText: input, rowIndex: indexPath.row)
    cell.textLabel?.textColor = .appText
    cell.backgroundColor = .appBackground

    return cell
  }

}
