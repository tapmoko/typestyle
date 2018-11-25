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
    let unsorted = (mode == .styles) ? styles : decorations
    let favorited = unsorted.filter { isFavorited(transformer: $0) }
    let unfavorited = unsorted.filter { !isFavorited(transformer: $0) }
    transformersToDisplay = favorited + unfavorited
  }

  func transformedText(for text: String, index: Int) -> String {
    return transformersToDisplay[index].transform(text)
  }

}

// MARK: Favoriting

extension TransformerManager {

  func isFavorited(at index: Int) -> Bool {
    return isFavorited(transformer: transformersToDisplay[index])
  }

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
