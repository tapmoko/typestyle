import UIKit

class InputContainerView: UIView {

  let inputTextView = UITextView()
  let inputTextViewRadius: CGFloat = 10
  let inputTextViewPadding: CGFloat = 15
  let inputTextViewMargin: CGFloat = 10

  override init(frame: CGRect) {
    super.init(frame: frame)

    setUpInputTextView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpInputTextView() {
    inputTextView.isEditable = true
    inputTextView.isScrollEnabled = false

    inputTextView.keyboardAppearance = .dark
    inputTextView.textColor = .appBackground
    inputTextView.tintColor = .appBackground
    inputTextView.font = UIFont.preferredFont(forTextStyle: .title1)
    inputTextView.backgroundColor = .appText
    inputTextView.layer.cornerRadius = inputTextViewRadius
    inputTextView.textContainerInset = UIEdgeInsets(top: inputTextViewPadding, left: inputTextViewPadding, bottom: inputTextViewPadding, right: inputTextViewPadding)

    addSubview(inputTextView)

    inputTextView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(inputTextViewMargin)
      make.left.equalToSuperview().offset(inputTextViewMargin)
      make.right.equalToSuperview().offset(-inputTextViewMargin)
      make.bottom.equalToSuperview().offset(-inputTextViewMargin)
    }
  }

}
