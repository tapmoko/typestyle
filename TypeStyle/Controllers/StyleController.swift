import UIKit
import SnapKit

class StyleController: UIViewController {

  let tableView = UITableView()
  let inputTextView = InputTextView()
  let inputTextViewPadding: CGFloat = 10

  var input = ""

  var isInitialAppearance = true

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(StyleCell.self, forCellReuseIdentifier: StyleCell.identifier)

    setUpInputTextView()
    setUpTableView()
  }

  func setUpInputTextView() {
    inputTextView.delegate = self

    view.addSubview(inputTextView)

    inputTextView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(inputTextViewPadding)
      make.left.equalToSuperview().offset(inputTextViewPadding)
      make.right.equalToSuperview().offset(-inputTextViewPadding)
    }
  }

  func setUpTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .appBackground
    tableView.separatorStyle = .none

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.top.equalTo(inputTextView.snp.bottom).offset(inputTextViewPadding)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard isInitialAppearance else { return }

    inputTextView.becomeFirstResponder()
    isInitialAppearance = false
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
    inputTextView.resignFirstResponder()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedString = StyleManager.shared.styledText(forText: input, rowIndex: indexPath.row)
    UIPasteboard.general.string = selectedString

    let alertController = UIAlertController(title: "Copied",
                                            message: selectedString,
                                            preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK",
                                            style: .default,
                                            handler: nil))
    present(alertController, animated: true, completion: nil)
  }

}

extension StyleController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    input = inputTextView.text ?? ""
    tableView.reloadData()
  }

}
