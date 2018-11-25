import UIKit
import SnapKit
import CoreServices

class TypeStyleController: UIViewController {

  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  var isInitialAppearance = true
  let feedbackGenerator = UINotificationFeedbackGenerator()

  let inputContainerView = InputContainerView()
  let tableView = UITableView()
  let modeSegmentedControl = UISegmentedControl(items: ["Styles", "Decorations"])
  let copiedView = CopiedView()
  let infoButton = UIButton(type: .infoLight)

  let generalMargin: CGFloat = 15

  var input = ""

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(OutputCell.self, forCellReuseIdentifier: OutputCell.identifier)

    setUpInputContainerView()
    setUpModeSegmentedControl()
    setUpTableView()
    setUpCopiedView()
    setUpInfoButton()
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
      make.centerX.equalToSuperview()
      make.left.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.left).offset(generalMargin)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-generalMargin)
    }
  }

  func setUpInfoButton() {
    infoButton.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
    infoButton.tintColor = .appText

    view.addSubview(infoButton)

    infoButton.snp.makeConstraints { make in
      make.centerY.equalTo(modeSegmentedControl.snp.centerY)
      make.left.equalTo(modeSegmentedControl.snp.right).offset(generalMargin)
      make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-generalMargin)
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

  @objc func didTapInfoButton() {

  }

  func refreshUI() {
    input = inputContainerView.inputTextView.text ?? ""
    inputContainerView.clearButton.isHidden = input.isEmpty
    tableView.reloadData()
  }

  @objc func modeDidChange() {
    switch modeSegmentedControl.selectedSegmentIndex {
    case 0: TransformerManager.shared.set(mode: .styles)
    case 1: TransformerManager.shared.set(mode: .decorations)
    default: break
    }
    refreshUI()
  }

  func output(for indexPath: IndexPath) -> String {
    return TransformerManager.shared.transformedText(for: input, index: indexPath.row)
  }

}

extension TypeStyleController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if input.isEmpty { return 0 } // Don't show output cells if input is empty
    return TransformerManager.shared.transformersToDisplay.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: OutputCell.identifier) as! OutputCell
    cell.outputLabel.text = output(for: indexPath)
    cell.favoriteLabel.text = TransformerManager.shared.isFavorited(at: indexPath.row) ? "\u{2661}\u{0000FE0E}" : ""
    return cell
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let favoriteAction = UITableViewRowAction(style: .normal, title: "Favorite", handler: didFavorite)
    favoriteAction.backgroundColor = .appDarkBackground

    return [favoriteAction]
  }

  func didFavorite(rowAction: UITableViewRowAction, at indexPath: IndexPath) {
    let transformer = TransformerManager.shared.transformersToDisplay[indexPath.row]
    TransformerManager.shared.toggleFavorite(transformer: transformer)
    TransformerManager.shared.updateTransformersToDisplay()
    refreshUI()
  }

}

extension TypeStyleController: UITableViewDelegate {

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    inputContainerView.inputTextView.resignFirstResponder()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    inputContainerView.inputTextView.resignFirstResponder()

    let selectedString = output(for: indexPath)
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
    let draggedValue = output(for: indexPath).data(using: .utf8)

    let itemProvider = NSItemProvider()
    let typeIdentifier = kUTTypePlainText as String

    itemProvider.registerDataRepresentation(forTypeIdentifier: typeIdentifier, visibility: .all) { completion in
      completion(draggedValue, nil)
      return nil
    }

    return [UIDragItem(itemProvider: itemProvider)]
  }

}
