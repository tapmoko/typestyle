import UIKit
import SnapKit
import CoreServices

class GeneratorViewController: UIViewController {

  enum ViewMode {
    case generate
    case browse
  }

  // MARK: - Properties

  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  let feedbackGenerator = UINotificationFeedbackGenerator()
  var transformerManager: TransformerManager

  let inputContainerView = InputContainerView()
  var inputPlaceholder: String {
    (viewMode == .generate) ? "Your text..." : "Search..."
  }

  let tableView = UITableView()

  let viewModeSegmentedControl = UISegmentedControl(items: ["Generate", "Browse"])

  let actionConfirmationView = ActionConfirmationView()
  var actionConfirmationViewTimer: Timer?

  let generalMargin: CGFloat = 15

  var viewMode: ViewMode = .generate

  var input = ""

  // MARK: - Initialization

  init(transformerMode: TransformerManager.Mode) {
    transformerManager = TransformerManager(mode: transformerMode)

    // Browsing is the only view mode for emoticons
    if transformerMode == .emoticons { viewMode = .browse }

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View setup

  override func viewDidLoad() {
    super.viewDidLoad()

    overrideUserInterfaceStyle = .dark

    view.backgroundColor = .appBackground

    setUpInputContainerView()
    setUpModeSegmentedControl()
    setUpTableView()
    setUpActionConfirmationView()
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

    viewModeSegmentedControl.tintColor = .appText
    viewModeSegmentedControl.selectedSegmentIndex = 0
    viewModeSegmentedControl.addTarget(self, action: #selector(modeDidChange), for: .valueChanged)

    // TODO: Make this adjust automatically somehow, not just on app launch
    let font = UIFont.preferredFont(forTextStyle: .body)
    viewModeSegmentedControl.setTitleTextAttributes([.font: font], for: .normal)

    view.addSubview(viewModeSegmentedControl)

    viewModeSegmentedControl.snp.makeConstraints { make in
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
        make.bottom.equalTo(viewModeSegmentedControl.snp.top).offset(-generalMargin)
      } else {
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      }
    }
  }

  func setUpActionConfirmationView() {
    view.addSubview(actionConfirmationView)

    actionConfirmationView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    actionConfirmationView.isHidden = true
    actionConfirmationView.alpha = 0
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

  // MARK: - Instance methods

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

    transformerManager.updateTransformersToDisplay(filterInput: (viewMode == .browse) ? input : nil)

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
    switch viewModeSegmentedControl.selectedSegmentIndex {
    case 0: viewMode = .generate
    case 1: viewMode = .browse
    default: break
    }
    refreshUI()
  }

  func output(for indexPath: IndexPath) -> String {
    return transformerManager.transformedText(for: (viewMode == .generate) ? input : nil,
                                              indexPath: indexPath)
  }

}

// MARK: - UITableViewDataSource

extension GeneratorViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return transformerManager.transformerGroupingsToDisplay.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Don't show output cells if we are in generate mode and input is empty
    if viewMode == .generate && input.isEmpty {
      return 0
    }

    return transformerManager.transformerGroupingsToDisplay[section].transformers.count
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch transformerManager.mode {
    case .styles, .decorations: return nil
    case .emoticons: return transformerManager.transformerGroupingsToDisplay[section].groupName
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: OutputTableViewCell.identifier) as! OutputTableViewCell
    cell.outputLabel.text = output(for: indexPath)
    cell.favoriteImageView.image = transformerManager.isFavorited(at: indexPath)
      ? UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
      : nil
    return cell
  }

  func tableView(_ tableView: UITableView,
                 trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let favoriteTitle = transformerManager.isFavorited(at: indexPath) ? "Unfavorite" : "Favorite"
    let favoriteAction = UIContextualAction(style: .normal, title: favoriteTitle) {
      (contextualAction, view, boolValue) in

      let transformer = self.transformerManager.transformerGroupingsToDisplay[indexPath.section].transformers[indexPath.row]
      self.transformerManager.toggleFavorite(transformer: transformer)
      self.transformerManager.updateTransformersToDisplay()
      self.refreshUI()
    }
    favoriteAction.backgroundColor = .appDarkBackground

    return UISwipeActionsConfiguration(actions: [favoriteAction])
  }

}

// MARK: - UITableViewDelegate

extension GeneratorViewController: UITableViewDelegate {

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    inputContainerView.inputTextView.resignFirstResponder()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    inputContainerView.inputTextView.resignFirstResponder()

    if viewMode == .generate || (viewMode == .browse && transformerManager.mode == .emoticons) {
      let selectedString = output(for: indexPath)
      UIPasteboard.general.string = selectedString
      actionConfirmationView.style = .copied
    } else {
      // Favorite or unfavorite
      let transformer = transformerManager.transformerGroupingsToDisplay[indexPath.section].transformers[indexPath.row]
      transformerManager.toggleFavorite(transformer: transformer)
      actionConfirmationView.style = self.transformerManager.isFavorited(at: indexPath) ? .favorited : .unfavorited
      refreshUI()
    }

    showActionConfirmationView()
    feedbackGenerator.notificationOccurred(.success)
  }

  func showActionConfirmationView() {
    actionConfirmationViewTimer?.invalidate()
    actionConfirmationViewTimer = nil
    actionConfirmationView.alpha = 0
    actionConfirmationView.isHidden = false
    UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
      self.actionConfirmationView.alpha = 1
    }, completion: { _ in
      self.actionConfirmationViewTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                                  target: self,
                                                  selector: #selector(self.hideActionConfirmationView),
                                                  userInfo: nil,
                                                  repeats: false)
    })
  }

  @objc func hideActionConfirmationView() {
    actionConfirmationViewTimer?.invalidate()
    actionConfirmationViewTimer = nil
    UIView.animate(withDuration: 0.1, animations: {
      self.actionConfirmationView.alpha = 0
    }, completion: { _ in
      self.actionConfirmationView.isHidden = true
    })
  }

}

// MARK: - UITextViewDelegate

extension GeneratorViewController: UITextViewDelegate {

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

extension GeneratorViewController: UITableViewDragDelegate {

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
