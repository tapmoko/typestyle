import UIKit
import SnapKit

class TypeStyleController: UIViewController {

  enum Mode {
    case styles
    case decorations
  }

  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  var isInitialAppearance = true
  let feedbackGenerator = UINotificationFeedbackGenerator()

  let inputContainerView = InputContainerView()
  let tableView = UITableView()
  let modeSegmentedControl = UISegmentedControl(items: ["Styles", "Decorations"])
  let copiedView = CopiedView()

  let generalMargin: CGFloat = 15

  var input = ""
  var mode: Mode = .styles

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(StyleCell.self, forCellReuseIdentifier: StyleCell.identifier)

    setUpInputContainerView()
    setUpModeSegmentedControl()
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

  func setUpModeSegmentedControl() {
    modeSegmentedControl.tintColor = .appText
    modeSegmentedControl.selectedSegmentIndex = 0
    modeSegmentedControl.addTarget(self, action: #selector(modeDidChange), for: .valueChanged)

    view.addSubview(modeSegmentedControl)

    modeSegmentedControl.snp.makeConstraints { make in
      make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(generalMargin)
      make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-generalMargin)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-generalMargin)
    }
  }

  func setUpTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = nil
    tableView.separatorStyle = .none

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.top.equalTo(inputContainerView.snp.bottom)
      make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
      make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
      make.bottom.equalTo(modeSegmentedControl.snp.top).offset(-generalMargin)
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

  @objc func modeDidChange() {
    switch modeSegmentedControl.selectedSegmentIndex {
    case 0: mode = .styles
    case 1: mode = .decorations
    default: break
    }

    refreshUI()
  }

}

extension TypeStyleController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if input.isEmpty { return 0 } // Don't show output cells if input is empty
    return (mode == .styles) ? StyleManager.shared.styles.count
                             : DecorationManager.shared.decorations.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StyleCell.identifier) as! StyleCell

    switch mode {
    case .styles: cell.outputLabel.text = StyleManager.shared.styledText(forText: input,
                                                                         rowIndex: indexPath.row)
    case .decorations: cell.outputLabel.text = DecorationManager.shared.decoratedText(forText: input,
                                                                                      rowIndex: indexPath.row)
    }

    return cell
  }

}

extension TypeStyleController: UITableViewDelegate {

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    inputContainerView.inputTextView.resignFirstResponder()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    inputContainerView.inputTextView.resignFirstResponder()

    var selectedString = ""
    switch mode {
    case .styles: selectedString = StyleManager.shared.styledText(forText: input, rowIndex: indexPath.row)
    case .decorations: selectedString = DecorationManager.shared.decoratedText(forText: input, rowIndex: indexPath.row)
    }

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

extension TypeStyleController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    refreshUI()
  }

}
