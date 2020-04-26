import Foundation

struct TransformerManager {

  enum Mode {
    case styles
    case decorations
    case emoticons
  }

  let mode: Mode

  let transformers: [Transformer]
  var transformersToDisplay: [Transformer] = []
  var filteredTransformersToDisplay: [Transformer] = []

  init(mode: Mode) {
    self.mode = mode

    switch mode {
    case .styles: self.transformers = StyleFactory.allStyles()
    case .decorations: self.transformers = DecorationFactory.allDecorations()
    case .emoticons: self.transformers = EmoticonFactory.allEmoticons()
    }

    updateTransformersToDisplay()
  }

  mutating func updateTransformersToDisplay() {
    let favorited = transformers.filter { isFavorited(transformer: $0) }
    let unfavorited = transformers.filter { !isFavorited(transformer: $0) }
    transformersToDisplay = favorited + unfavorited
  }

  func transformedText(for text: String?, index: Int) -> String {
    // If no text is provided, we use the name of the transformer.
    return transformersToDisplay[index].transform(text ?? transformersToDisplay[index].name)
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
