import UIKit
import SnapKit

class StyleController: UIViewController {

  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  var isInitialAppearance = true
  let feedbackGenerator = UINotificationFeedbackGenerator()

  let tableView = UITableView()
  let inputContainerView = InputContainerView()
  let copiedView = CopiedView()

  var input = ""

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(StyleCell.self, forCellReuseIdentifier: StyleCell.identifier)

    setUpInputContainerView()
    setUpTableView()
    setUpCopiedView()
  }

  func setUpInputContainerView() {
    inputContainerView.inputTextView.delegate = self
    inputContainerView.clearButton.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)

    view.addSubview(inputContainerView)

    inputContainerView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
      make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
    }
  }

  func setUpTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .appBackground
    tableView.separatorStyle = .none

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.top.equalTo(inputContainerView.snp.bottom)
      make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
      make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }

  func setUpCopiedView() {
    view.addSubview(copiedView)

    copiedView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    copiedView.isHidden = true
    copiedView.alpha = 0
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard isInitialAppearance else { return }

    inputContainerView.inputTextView.becomeFirstResponder()
    isInitialAppearance = false
  }

  @objc func didTapClearButton() {
    inputContainerView.inputTextView.text = ""
    refreshUI()
    inputContainerView.inputTextView.becomeFirstResponder()
  }

  func refreshUI() {
    input = inputContainerView.inputTextView.text ?? ""
    inputContainerView.clearButton.isHidden = input.isEmpty
    tableView.reloadData()
  }

}

extension StyleController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if input.isEmpty { return 0 } // Don't show output cells if input is empty
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
    inputContainerView.inputTextView.resignFirstResponder()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    inputContainerView.inputTextView.resignFirstResponder()

    let selectedString = StyleManager.shared.styledText(forText: input, rowIndex: indexPath.row)
    UIPasteboard.general.string = selectedString

    feedbackGenerator.notificationOccurred(.success)
    showCopiedView()
  }

  func showCopiedView() {
    copiedView.isHidden = false
    UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
      self.copiedView.alpha = 1
    }, completion: { _ in
      self.hideCopiedView()
    })
  }

  func hideCopiedView() {
    UIView.animate(withDuration: 0.1, delay: 0.5, options: [], animations: {
      self.copiedView.alpha = 0
    }, completion: { _ in
      self.copiedView.isHidden = true
    })
  }

}

extension StyleController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    refreshUI()
  }

}
