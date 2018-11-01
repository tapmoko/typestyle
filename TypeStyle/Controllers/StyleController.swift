import UIKit
import SnapKit

class StyleController: UIViewController {

  let tableView = UITableView()
  let inputField = InputField()
  let inputFieldPadding: CGFloat = 10

  var input = ""

  var isInitialAppearance = true

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(StyleCell.self, forCellReuseIdentifier: StyleCell.identifier)

    setUpInputField()
    setUpTableView()
  }

  func setUpInputField() {
    inputField.addTarget(self, action: #selector(inputFieldDidChange), for: .editingChanged)

    view.addSubview(inputField)

    inputField.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(inputFieldPadding)
      make.left.equalToSuperview().offset(inputFieldPadding)
      make.right.equalToSuperview().offset(-inputFieldPadding)
    }
  }

  func setUpTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .appBackground
    tableView.separatorStyle = .none

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.top.equalTo(inputField.snp.bottom).offset(inputFieldPadding)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard isInitialAppearance else { return }

    inputField.becomeFirstResponder()
    isInitialAppearance = false
  }

  @objc func inputFieldDidChange() {
    input = inputField.text ?? ""
    tableView.reloadData()
  }

}

extension StyleController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return StyleManager.shared.styles.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StyleCell.identifier) as! StyleCell

    cell.outputLabel.text = StyleManager.shared.styledText(forText: input, rowIndex: indexPath.row)

    return cell
  }

}

extension StyleController: UITableViewDelegate {

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    inputField.resignFirstResponder()
  }

}
