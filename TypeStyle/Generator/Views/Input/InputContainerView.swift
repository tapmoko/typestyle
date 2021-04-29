import UIKit
import SwiftUI
import SnapKit

protocol InputContainerViewDelegate {
  func textViewDidBeginEditing(inputContainerView: InputContainerView)
  func textViewDidChange(inputContainerView: InputContainerView)
  func textViewDidEndEditing(inputContainerView: InputContainerView)
}

class InputContainerView: UIView {

  let inputTextView = UITextView()
  let inputTextViewContainer = UIView()

  var delegate: InputContainerViewDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    setUpInputTextView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpInputTextView() {
    // Delegate
    inputTextView.delegate = self

    // Editing
    inputTextView.isEditable = true
    inputTextView.isScrollEnabled = false

    // Keyboard
    inputTextView.keyboardAppearance = .dark

    // Color
    inputTextView.textColor = UIColor(Color.appText)
    inputTextView.tintColor = UIColor(Color.appText)
    inputTextView.backgroundColor = UIColor(Color.appDarkBackground)

    // Font
    setTextSize(.title2)
    inputTextView.adjustsFontForContentSizeCategory = true

    addSubview(inputTextView)

    inputTextView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func setTextSize(_ size: UIFont.TextStyle) {
    inputTextView.font = UIFont.preferredFont(forTextStyle: size)
  }

}

extension InputContainerView: UITextViewDelegate {

  func textViewDidBeginEditing(_ textView: UITextView) {
    delegate?.textViewDidBeginEditing(inputContainerView: self)
  }

  func textViewDidChange(_ textView: UITextView) {
    delegate?.textViewDidChange(inputContainerView: self)
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    delegate?.textViewDidEndEditing(inputContainerView: self)
  }

}
