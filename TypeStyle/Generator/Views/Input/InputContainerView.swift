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

  let inputTextViewRadius: CGFloat = 10
  let inputTextViewPadding: CGFloat = 15
  let inputTextViewMargin: CGFloat = 10

  var delegate: InputContainerViewDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    setUpInputTextViewContainer()
    setUpInputTextView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpInputTextViewContainer() {
    inputTextViewContainer.layer.cornerRadius = inputTextViewRadius
    inputTextViewContainer.backgroundColor = UIColor(Color.appDarkBackground)

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

    // Shape
    inputTextView.layer.cornerRadius = inputTextViewRadius
    inputTextView.textContainerInset = UIEdgeInsets(
        top: inputTextViewPadding,
        left: inputTextViewPadding,
        bottom: inputTextViewPadding,
        right: inputTextViewPadding
    )

    inputTextViewContainer.addSubview(inputTextView)

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
