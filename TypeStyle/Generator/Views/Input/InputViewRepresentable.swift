import SwiftUI

struct InputViewRepresentable: UIViewRepresentable {

  @Binding var input: String
  @Binding var viewMode: GeneratorView.ViewMode

  var inputPlaceholder: String {
    (viewMode == .generate) ? "Your text..." : "Search..."
  }

  func makeUIView(context: Context) -> InputContainerView {
    let inputContainerView = InputContainerView()

    inputContainerView.delegate = context.coordinator
//    inputContainerView.inputTextView.delegate = context.coordinator

    return inputContainerView
  }

  func updateUIView(_ uiView: InputContainerView, context: Context) {

  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  final class Coordinator: NSObject, InputContainerViewDelegate {

    var control: InputViewRepresentable

    init(_ control: InputViewRepresentable) {
      self.control = control
    }

    func showInputPlaceholder(inputTextView: UITextView) {
      inputTextView.text = control.inputPlaceholder
      inputTextView.textColor = UIColor(Color.appFadedText)
    }

    func hideInputPlaceholder(inputTextView: UITextView) {
      inputTextView.text = nil
      inputTextView.textColor = UIColor(Color.appText)
    }

    func refreshUI(inputContainerView: InputContainerView) {
      if inputContainerView.inputTextView.textColor == UIColor(Color.appFadedText) {
        control.input = ""
      } else {
        control.input = inputContainerView.inputTextView.text ?? ""
      }

      inputContainerView.clearButton.isHidden = control.input.isEmpty || (inputContainerView.inputTextView.textColor == UIColor(Color.appFadedText))
      //          tableView.reloadData()

      if control.input.isEmpty {
        showInputPlaceholder(inputTextView: inputContainerView.inputTextView)
      }

      if control.input.count > 200 {
        inputContainerView.setTextSize(.footnote)
      } else if control.input.count > 100 {
        inputContainerView.setTextSize(.body)
      } else {
        inputContainerView.setTextSize(.title2)
      }
    }

    // MARK: - InputContainerViewDelegate

    func textViewDidBeginEditing(inputContainerView: InputContainerView) {
      if inputContainerView.inputTextView.textColor == UIColor(Color.appFadedText) {
        hideInputPlaceholder(inputTextView: inputContainerView.inputTextView)
      }
    }

    func textViewDidChange(inputContainerView: InputContainerView) {
      refreshUI(inputContainerView: inputContainerView)
    }

    func textViewDidEndEditing(inputContainerView: InputContainerView) {
      if inputContainerView.inputTextView.text.isEmpty {
        showInputPlaceholder(inputTextView: inputContainerView.inputTextView)
      }

      refreshUI(inputContainerView: inputContainerView)
    }

    func didTapClearButton(inputContainerView: InputContainerView) {
      inputContainerView.inputTextView.resignFirstResponder()
      inputContainerView.inputTextView.text = nil
      refreshUI(inputContainerView: inputContainerView)
      inputContainerView.inputTextView.becomeFirstResponder()
    }

  }

}
