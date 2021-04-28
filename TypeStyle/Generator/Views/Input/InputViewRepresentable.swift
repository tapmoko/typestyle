import SwiftUI

struct InputViewRepresentable: UIViewRepresentable {

    @Binding var input: String
    @Binding var viewMode: GeneratorView.ViewMode

    var inputPlaceholder: String {
      (viewMode == .generate) ? "Your text..." : "Search..."
    }

    func makeUIView(context: Context) -> InputContainerView {
        let inputContainerView = InputContainerView()

        inputContainerView.inputTextView.delegate = context.coordinator

        return inputContainerView
    }

    func updateUIView(_ uiView: InputContainerView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
      Coordinator(self)
    }

    final class Coordinator: NSObject, UITextViewDelegate {

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

//          transformerManager.updateTransformersToDisplay(filterInput: (viewMode == .browse) ? input : nil)

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

        // MARK: - UITextViewDelegate

        func textViewDidBeginEditing(_ textView: UITextView) {
          if textView.textColor == UIColor(Color.appFadedText) {
            hideInputPlaceholder(inputTextView: textView)
          }
        }

        func textViewDidChange(_ textView: UITextView) {
          refreshUI(inputContainerView: textView.superview?.superview as! InputContainerView)
        }

        func textViewDidEndEditing(_ textView: UITextView) {
          if textView.text.isEmpty {
            showInputPlaceholder(inputTextView: textView)
          }

          refreshUI(inputContainerView: textView.superview?.superview as! InputContainerView)
        }

    }

}
