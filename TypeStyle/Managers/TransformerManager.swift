import Foundation

struct TransformerManager {

  enum Mode {
    case styles
    case decorations
  }

  static var shared = TransformerManager()

  let styleInputBase = StyleFactory.inputBase()
  let styles = StyleFactory.allStyles()
  let decorations = DecorationFactory.allDecorations()
  
  var mode: Mode = .styles
  var transformersToDisplay = StyleFactory.allStyles()

  mutating func set(mode: Mode) {
    self.mode = mode
    updateTransformersToDisplay()
  }

  mutating func updateTransformersToDisplay() {
    let unsortedTransformers = (mode == .styles) ? styles : decorations
    transformersToDisplay = unsortedTransformers.sorted() { first, second in
      isFavorited(transformer: first)
    }
  }

  func transformedText(for text: String, index: Int) -> String {
    return transformersToDisplay[index].transform(text)
  }

}

// MARK: Favoriting

extension TransformerManager {

  func isFavorited(transformer: Transformer) -> Bool {
    return UserDefaults.standard.bool(forKey: String.localizedStringWithFormat(transformerFavoritedKey,
                                                                               transformer.name))
  }

  func toggleFavorite(transformer: Transformer) {
    UserDefaults.standard.set(!isFavorited(transformer: transformer),
                              forKey: String.localizedStringWithFormat(transformerFavoritedKey,
                                                                       transformer.name))
  }

}
