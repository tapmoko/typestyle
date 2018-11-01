import UIKit
import SnapKit

class StyleController: UIViewController {

  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  var isInitialAppearance = true
  let feedbackGenerator = UINotificationFeedbackGenerator()

  let tableView = UITableView()
  let inputTextView = InputTextView()
  let inputTextViewMargin: CGFloat = 10
  let copiedView = CopiedView()

  var input = ""

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(StyleCell.self, forCellReuseIdentifier: StyleCell.identifier)

    setUpInputTextView()
    setUpTableView()
    setUpCopiedView()
  }

  func setUpInputTextView() {
    inputTextView.delegate = self

    view.addSubview(inputTextView)

    inputTextView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(inputTextViewMargin)
      make.left.equalToSuperview().offset(inputTextViewMargin)
      make.right.equalToSuperview().offset(-inputTextViewMargin)
    }
  }

  func setUpTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .appBackground
    tableView.separatorStyle = .none

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.top.equalTo(inputTextView.snp.bottom).offset(inputTextViewMargin)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
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
    inputTextView.resignFirstResponder()

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
    UIView.animate(withDuration: 0.1, delay: 1, options: [], animations: {
      self.copiedView.alpha = 0
    }, completion: { _ in
      self.copiedView.isHidden = true
    })
  }

}

extension StyleController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    input = inputTextView.text ?? ""
    tableView.reloadData()
  }

}
