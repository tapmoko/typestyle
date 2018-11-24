import UIKit
import SnapKit
import CoreServices

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

    tableView.register(OutputCell.self, forCellReuseIdentifier: OutputCell.identifier)

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

    // TODO: Make this adjust automatically somehow, not just on app launch
    let font = UIFont.preferredFont(forTextStyle: .body)
    modeSegmentedControl.setTitleTextAttributes([.font: font], for: .normal)

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
    tableView.dragDelegate = self
    tableView.backgroundColor = .appBackground
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

  func output(forIndexPath indexPath: IndexPath) -> String {
    switch mode {
    case .styles: return TransformerManager.shared.styledText(for: input, index: indexPath.row)
    case .decorations: return TransformerManager.shared.decoratedText(for: input, index: indexPath.row)
    }
  }

}

extension TypeStyleController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if input.isEmpty { return 0 } // Don't show output cells if input is empty
    return (mode == .styles) ? TransformerManager.shared.styles.count
                             : TransformerManager.shared.decorations.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: OutputCell.identifier) as! OutputCell
    cell.outputLabel.text = output(forIndexPath: indexPath)
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
    case .styles: selectedString = TransformerManager.shared.styledText(for: input, index: indexPath.row)
    case .decorations: selectedString = TransformerManager.shared.decoratedText(for: input, index: indexPath.row)
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

  func textViewDidEndEditing(_ textView: UITextView) {
    refreshUI()
  }

}

extension TypeStyleController: UITableViewDragDelegate {

  func tableView(_ tableView: UITableView,
                 itemsForBeginning session: UIDragSession,
                 at indexPath: IndexPath) -> [UIDragItem] {
    let draggedValue = output(forIndexPath: indexPath).data(using: .utf8)

    let itemProvider = NSItemProvider()
    let typeIdentifier = kUTTypePlainText as String

    itemProvider.registerDataRepresentation(forTypeIdentifier: typeIdentifier, visibility: .all) { completion in
      completion(draggedValue, nil)
      return nil
    }

    return [UIDragItem(itemProvider: itemProvider)]
  }

}
