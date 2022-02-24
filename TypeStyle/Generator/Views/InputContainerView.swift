import UIKit

class InputContainerView: UIView {

  // MARK: - Public properties

  lazy var inputTextView: UITextView = {
    let inputTextView = UITextView()

    // Editing
    inputTextView.isEditable = true
    inputTextView.isScrollEnabled = false

    // Keyboard
    inputTextView.keyboardAppearance = .dark

    // Color
    inputTextView.textColor = .appText
    inputTextView.tintColor = .appText
    inputTextView.backgroundColor = .appDarkBackground

    // Font
    inputTextView.font = UIFont.preferredFont(forTextStyle: .title2)
    inputTextView.adjustsFontForContentSizeCategory = true

    // Shape
    inputTextView.layer.cornerRadius = inputTextViewRadius
    inputTextView.textContainerInset = UIEdgeInsets(
      top: inputTextViewPadding,
      left: inputTextViewPadding,
      bottom: inputTextViewPadding,
      right: inputTextViewPadding
    )

    return inputTextView
  }()

  lazy var inputTextViewContainer: UIView = {
    let inputTextViewContainer = UIView()

    inputTextViewContainer.layer.cornerRadius = inputTextViewRadius
    inputTextViewContainer.backgroundColor = .appDarkBackground

    return inputTextViewContainer
  }()

  let clearButton: UIButton = {
    let clearButton = UIButton()

    clearButton.setTitle("×", for: .normal)
    clearButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
    clearButton.titleLabel?.adjustsFontForContentSizeCategory = true
    clearButton.setTitleColor(.appText, for: .normal)
    clearButton.isHidden = true

    return clearButton
  }()

  // MARK: - Private properties

  private let inputTextViewRadius = 10.0
  private let inputTextViewPadding = 15.0
  private let inputTextViewMargin = 10.0

  // MARK: - Setup

  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)

    setUpShadow()
    addSubviews()
  }

  private func setUpShadow() {
    layer.shadowRadius = 8
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.3
  }

  private func addSubviews() {
    addSubview(inputTextViewContainer)

    inputTextViewContainer.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(inputTextViewMargin)
    }

    inputTextViewContainer.addSubview(clearButton)

    clearButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(inputTextViewPadding)
    }

    inputTextViewContainer.addSubview(inputTextView)

    inputTextView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.bottom.equalToSuperview()
      make.trailing.equalTo(clearButton.snp.leading)
    }
  }

  // MARK: - Public methods

  func setTextSize(_ size: UIFont.TextStyle) {
    inputTextView.font = UIFont.preferredFont(forTextStyle: size)
  }

}
