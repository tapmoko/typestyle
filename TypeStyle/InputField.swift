import UIKit

class InputField: UITextField {

  init() {
    super.init(frame: .zero)

    keyboardAppearance = .dark
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
