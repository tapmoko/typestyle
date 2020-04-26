import UIKit
import SnapKit
import CoreServices

class TypeStyleViewController: UIViewController {

  enum ViewMode {
    case generate
    case browse
  }

  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  let feedbackGenerator = UINotificationFeedbackGenerator()
  var transformerManager: TransformerManager

  let inputContainerView = InputContainerView()
  var inputPlaceholder: String {
    (viewMode == .generate) ? "Your text..." : "Search..."
  }

  let tableView = UITableView()
  let modeSegmentedControl = UISegmentedControl(items: ["Generate", "Browse"])
  let copiedView = CopiedView()
  var copiedViewTimer: Timer?
  let aboutButton = UIButton(type: .infoLight)
  let generalMargin: CGFloat = 15

  var viewMode: ViewMode = .generate

  init(transformerMode: TransformerManager.Mode) {
    transformerManager = TransformerManager(mode: transformerMode)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var input = ""

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .appBackground

    setUpInputContainerView()
    setUpModeSegmentedControl()
    setUpTableView()
    setUpCopiedView()
  }

  func setUpInputContainerView() {
    inputContainerView.inputTextView.delegate = self
    inputContainerView.inputTextView.textColor = .appFadedText

    inputContainerView.clearButton.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)

    view.addSubview(inputContainerView)

    inputContainerView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
    }
  }

  func setUpModeSegmentedControl() {
    guard transformerManager.mode != .emoticons else {
      return
    }

    modeSegmentedControl.tintColor = .appText
    modeSegmentedControl.selectedSegmentIndex = 0
    modeSegmentedControl.addTarget(self, action: #selector(modeDidChange), for: .valueChanged)

    // TODO: Make this adjust automatically somehow, not just on app launch
    let font = UIFont.preferredFont(forTextStyle: .body)
    modeSegmentedControl.setTitleTextAttributes([.font: font], for: .normal)

    view.addSubview(modeSegmentedControl)

    modeSegmentedControl.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.leading.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.leading).inset(generalMargin)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(generalMargin)
    }
  }

  func setUpTableView() {
    tableView.register(OutputTableViewCell.self, forCellReuseIdentifier: OutputTableViewCell.identifier)

    tableView.dataSource = self
    tableView.delegate = self
    tableView.dragDelegate = self
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.top.equalTo(inputContainerView.snp.bottom)
      make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)

      if transformerManager.mode != .emoticons {
        make.bottom.equalTo(modeSegmentedControl.snp.top).inset(generalMargin)
      } else {
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(generalMargin)
      }
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

    if (UIApplication.shared.delegate as? AppDelegate)?.didAutomaticallyShowKeyboardOnce ?? false {
      showInputPlaceholder()
      return
    }

    inputContainerView.inputTextView.becomeFirstResponder()
    (UIApplication.shared.delegate as? AppDelegate)?.didAutomaticallyShowKeyboardOnce = true
  }

  @objc func didTapClearButton() {
    inputContainerView.inputTextView.resignFirstResponder()
    inputContainerView.inputTextView.text = nil
    refreshUI()
    inputContainerView.inputTextView.becomeFirstResponder()
  }

  func refreshUI() {
    if inputContainerView.inputTextView.textColor == .appFadedText {
      input = ""
    } else {
      input = inputContainerView.inputTextView.text ?? ""
    }

    inputContainerView.clearButton.isHidden = input.isEmpty || (inputContainerView.inputTextView.textColor == .appFadedText)
    tableView.reloadData()

    if input.isEmpty {
      showInputPlaceholder()
    }

    if input.count > 200 {
      inputContainerView.setTextSize(.footnote)
    } else if input.count > 100 {
      inputContainerView.setTextSize(.body)
    } else {
      inputContainerView.setTextSize(.title2)
    }
  }

  func showInputPlaceholder() {
    inputContainerView.inputTextView.text = inputPlaceholder
    inputContainerView.inputTextView.textColor = .appFadedText
  }

  func hideInputPlaceholder() {
    inputContainerView.inputTextView.text = nil
    inputContainerView.inputTextView.textColor = .appText
  }

  @objc func modeDidChange() {
    inputContainerView.inputTextView.text = nil
    switch modeSegmentedControl.selectedSegmentIndex {
    case 0: viewMode = .generate
    case 1: viewMode = .browse
    default: break
    }
    refreshUI()
  }

  func output(for indexPath: IndexPath) -> String {
    return transformerManager.transformedText(for: input, index: indexPath.row)
  }

}

// MARK: - UITableViewDataSource

extension TypeStyleViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if input.isEmpty { return 0 } // Don't show output cells if input is empty
    return transformerManager.transformersToDisplay.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: OutputTableViewCell.identifier) as! OutputTableViewCell
    cell.outputLabel.text = output(for: indexPath)
    cell.favoriteImageView.image = transformerManager.isFavorited(at: indexPath.row)
      ? UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
      : nil
    return cell
  }

  func tableView(_ tableView: UITableView,
                 trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let favoriteTitle = transformerManager.isFavorited(at: indexPath.row) ? "Unfavorite" : "Favorite"
    let favoriteAction = UIContextualAction(style: .normal, title: favoriteTitle) {
      (contextualAction, view, boolValue) in

      let transformer = self.transformerManager.transformersToDisplay[indexPath.row]
      self.transformerManager.toggleFavorite(transformer: transformer)
      self.transformerManager.updateTransformersToDisplay()
      self.refreshUI()
    }
    favoriteAction.backgroundColor = .appDarkBackground

    return UISwipeActionsConfiguration(actions: [favoriteAction])
  }

}

// MARK: - UITableViewDelegate

extension TypeStyleViewController: UITableViewDelegate {

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
    copiedViewTimer?.invalidate()
    copiedViewTimer = nil
    copiedView.alpha = 0
    copiedView.isHidden = false
    UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
      self.copiedView.alpha = 1
    }, completion: { _ in
      self.copiedViewTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                                  target: self,
                                                  selector: #selector(self.hideCopiedView),
                                                  userInfo: nil,
                                                  repeats: false)
    })
  }

  @objc func hideCopiedView() {
    copiedViewTimer?.invalidate()
    copiedViewTimer = nil
    UIView.animate(withDuration: 0.1, animations: {
      self.copiedView.alpha = 0
    }, completion: { _ in
      self.copiedView.isHidden = true
    })
  }

}

// MARK: - UITextViewDelegate

extension TypeStyleViewController: UITextViewDelegate {

  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == .appFadedText {
      hideInputPlaceholder()
    }
  }

  func textViewDidChange(_ textView: UITextView) {
    refreshUI()
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      showInputPlaceholder()
    }

    refreshUI()
  }

}

// MARK: - UITableViewDragDelegate

extension TypeStyleViewController: UITableViewDragDelegate {

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
