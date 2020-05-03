import UIKit

class InputContainerView: UIView {

  let inputTextView = UITextView()
  let inputTextViewContainer = UIView()
  let clearButton = UIButton()

  let inputTextViewRadius: CGFloat = 10
  let inputTextViewPadding: CGFloat = 15
  let inputTextViewMargin: CGFloat = 10

  override init(frame: CGRect) {
    super.init(frame: frame)

    setUpInputTextViewContainer()
    setUpClearInputButton()
    setUpInputTextView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpInputTextViewContainer() {
    inputTextViewContainer.layer.cornerRadius = inputTextViewRadius
    inputTextViewContainer.backgroundColor = .appDarkBackground

    // Shadow
    layer.shadowRadius = 8
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.3

    addSubview(inputTextViewContainer)

    inputTextViewContainer.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(inputTextViewMargin)
    }
  }

  func setUpClearInputButton() {
    clearButton.setTitle("×", for: .normal)
    clearButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
    clearButton.titleLabel?.adjustsFontForContentSizeCategory = true
    clearButton.setTitleColor(.appText, for: .normal)
    clearButton.isHidden = true

    inputTextViewContainer.addSubview(clearButton)

    clearButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(inputTextViewPadding)
    }
  }

  func setUpInputTextView() {
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
    setTextSize(.title2)
    inputTextView.adjustsFontForContentSizeCategory = true

    // Shape
    inputTextView.layer.cornerRadius = inputTextViewRadius
    inputTextView.textContainerInset = UIEdgeInsets(top: inputTextViewPadding,
                                                    left: inputTextViewPadding,
                                                    bottom: inputTextViewPadding,
                                                    right: inputTextViewPadding)

    inputTextViewContainer.addSubview(inputTextView)

    inputTextView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.bottom.equalToSuperview()
      make.trailing.equalTo(clearButton.snp.leading)
    }
  }

  func setTextSize(_ size: UIFont.TextStyle) {
    inputTextView.font = UIFont.preferredFont(forTextStyle: size)
  }

}
