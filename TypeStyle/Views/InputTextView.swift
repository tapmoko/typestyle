import UIKit

class InputTextView: UITextView {

  let radius: CGFloat = 10
  let padding: CGFloat = 15

  init() {
    super.init(frame: .zero, textContainer: nil)

    isEditable = true
    isScrollEnabled = false

    keyboardAppearance = .dark
    textColor = .appBackground
    tintColor = .appBackground
    font = UIFont.preferredFont(forTextStyle: .title1)
    backgroundColor = .appText
    layer.cornerRadius = radius
    textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
