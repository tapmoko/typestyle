import UIKit

class InputTextView: UITextView {

  init() {
    super.init(frame: .zero, textContainer: nil)

    isEditable = true
    isScrollEnabled = false

    keyboardAppearance = .dark
    textColor = .appText
    font = UIFont.preferredFont(forTextStyle: .title1)
    tintColor = .appText
    backgroundColor = .appBackground
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
