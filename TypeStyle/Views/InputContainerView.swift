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
      make.top.equalToSuperview().offset(inputTextViewMargin)
      make.left.equalToSuperview().offset(inputTextViewMargin)
      make.right.equalToSuperview().offset(-inputTextViewMargin)
      make.bottom.equalToSuperview().offset(-inputTextViewMargin)
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
      make.right.equalToSuperview().offset(-inputTextViewPadding)
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
    inputTextView.font = UIFont.preferredFont(forTextStyle: .title2)
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
      make.left.equalToSuperview()
      make.bottom.equalToSuperview()
      make.right.equalTo(clearButton.snp.left)
    }
  }

}
