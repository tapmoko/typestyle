import UIKit

class InputField: UITextField {

  init() {
    super.init(frame: .zero)

    keyboardAppearance = .dark
    textColor = .appText
    font = UIFont.preferredFont(forTextStyle: .title1)
    tintColor = .appText
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
