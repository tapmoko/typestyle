import SwiftUI

struct InputViewRepresentable: UIViewRepresentable {

  @Binding var input: String
  @Binding var isInputFocused: Bool
  @Binding var viewMode: GeneratorView.ViewMode

  var inputPlaceholder: String {
    (viewMode == .generate) ? "Your text..." : "Search..."
  }

  func makeUIView(context: Context) -> UITextView {
    let inputTextView = UITextView()

    // Delegate
    inputTextView.delegate = context.coordinator

    // Editing
    inputTextView.isEditable = true
    inputTextView.isScrollEnabled = false

    // Keyboard
    inputTextView.keyboardAppearance = .dark

    // Color
    inputTextView.textColor = UIColor(Theme.appText)
    inputTextView.tintColor = UIColor(Theme.appText)
    inputTextView.backgroundColor = UIColor(Theme.appDarkBackground)

    // Font
    setTextSize(textView: inputTextView, size: .title2)
    inputTextView.adjustsFontForContentSizeCategory = true
    inputTextView.delegate = context.coordinator

    return inputTextView
  }

  func updateUIView(_ uiView: UITextView, context: Context) {
    if isInputFocused {
      uiView.becomeFirstResponder()
    } else {
      uiView.resignFirstResponder()
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func setTextSize(textView: UITextView, size: UIFont.TextStyle) {
    textView.font = UIFont.preferredFont(forTextStyle: size)
  }

  class Coordinator: NSObject, UITextViewDelegate {
    var control: InputViewRepresentable

    init(_ control: InputViewRepresentable) {
      self.control = control
    }

    func showInputPlaceholder(inputTextView: UITextView) {
      inputTextView.text = control.inputPlaceholder
      inputTextView.textColor = UIColor(Theme.appFadedText)
    }

    func hideInputPlaceholder(inputTextView: UITextView) {
      inputTextView.text = nil
      inputTextView.textColor = UIColor(Theme.appText)
    }

    func refreshUI(inputTextView: UITextView) {
      if inputTextView.textColor == UIColor(Theme.appFadedText) {
        control.input = ""
      } else {
        control.input = inputTextView.text ?? ""
      }

      if control.input.count > 200 {
        control.setTextSize(textView: inputTextView, size: .footnote)
      } else if control.input.count > 100 {
        control.setTextSize(textView: inputTextView, size: .body)
      } else {
        control.setTextSize(textView: inputTextView, size: .title2)
      }
    }

    // MARK: - UITextViewDelegate

    func textViewDidBeginEditing(_ textView: UITextView) {
      control.isInputFocused = true

      if textView.textColor == UIColor(Theme.appFadedText) {
        hideInputPlaceholder(inputTextView: textView)
      }
    }

    func textViewDidChange(_ textView: UITextView) {
      refreshUI(inputTextView: textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
      control.isInputFocused = false

      if textView.text.isEmpty {
        showInputPlaceholder(inputTextView: textView)
      }

      refreshUI(inputTextView: textView)
    }
  }

}
