import Foundation

struct DecorationManager {

  static let shared = DecorationManager()

  let decorations = DecorationFactory.allDecorations()

  func decoratedText(for text: String, index: Int) -> String {
    let decoration = decorations[index]
    return decoration.transform(text)
  }

}
