import Foundation

struct TransformerManager {

  static let shared = TransformerManager()

  let styleInputBase = StyleFactory.inputBase()
  let styles = StyleFactory.allStyles()
  let decorations = DecorationFactory.allDecorations()

  func styledText(for text: String, index: Int) -> String {
    let style = styles[index]
    return style.transform(text)
  }

  func decoratedText(for text: String, index: Int) -> String {
    let decoration = decorations[index]
    return decoration.transform(text)
  }

}
