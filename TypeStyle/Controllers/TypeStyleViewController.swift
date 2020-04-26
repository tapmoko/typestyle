import UIKit
import SnapKit
import CoreServices

class TypeStyleViewController: UIViewController {

  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  var isInitialAppearance = true
  let feedbackGenerator = UINotificationFeedbackGenerator()
  var transformerManager = TransformerManager()

  let inputContainerView = InputContainerView()
  let tableView = UITableView()
  let modeSegmentedControl = UISegmentedControl(items: ["Styles", "Decorations"])
  let copiedView = CopiedView()
  var copiedViewTimer: Timer?
  let aboutButton = UIButton(type: .infoLight)
  let generalMargin: CGFloat = 15

  var input = ""

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .appBackground

    setUpInputContainerView()
    setUpModeSegmentedControl()
    setUpTableView()
    setUpCopiedView()
    setUpAboutButton()
  }

  func setUpInputContainerView() {
    inputContainerView.inputTextView.delegate = self
    inputContainerView.clearButton.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)

    view.addSubview(inputContainerView)

    inputContainerView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
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
      make.leading.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.leading).inset(generalMargin)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(generalMargin)
    }
  }

  func setUpAboutButton() {
    aboutButton.addTarget(self, action: #selector(didTapAboutButton), for: .touchUpInside)
    aboutButton.tintColor = .appText

    view.addSubview(aboutButton)

    aboutButton.snp.makeConstraints { make in
      make.centerY.equalTo(modeSegmentedControl.snp.centerY)
      make.leading.equalTo(modeSegmentedControl.snp.trailing).inset(generalMargin)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(generalMargin)
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
      make.bottom.equalTo(modeSegmentedControl.snp.top).inset(generalMargin)
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

  @objc func didTapAboutButton() {
    let aboutVC = AboutViewController()
    let aboutNavigationVC = UINavigationController(rootViewController: aboutVC)
    present(aboutNavigationVC, animated: true, completion: nil)
  }

  func refreshUI() {
    input = inputContainerView.inputTextView.text ?? ""
    inputContainerView.clearButton.isHidden = input.isEmpty
    tableView.reloadData()

    if input.count > 200 {
      inputContainerView.setTextSize(.footnote)
    } else if input.count > 100 {
      inputContainerView.setTextSize(.body)
    } else {
      inputContainerView.setTextSize(.title2)
    }
  }

  @objc func modeDidChange() {
    switch modeSegmentedControl.selectedSegmentIndex {
    case 0: transformerManager.set(mode: .styles)
    case 1: transformerManager.set(mode: .decorations)
    default: break
    }
    refreshUI()
  }

  func output(for indexPath: IndexPath) -> String {
    return transformerManager.transformedText(for: input, index: indexPath.row)
  }

}

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

extension TypeStyleViewController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    refreshUI()
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    refreshUI()
  }

}

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
