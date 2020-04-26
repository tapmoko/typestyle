import Foundation

struct TransformerManager {

  enum Mode {
    case styles
    case decorations
    case emoticons
  }

  let styles = StyleFactory.allStyles()
  let decorations = DecorationFactory.allDecorations()
  let emoticons = EmoticonFactory.allEmoticons()
  
  let mode: Mode
  var transformersToDisplay = StyleFactory.allStyles()

  init(mode: Mode) {
    self.mode = mode
    updateTransformersToDisplay()
  }

  mutating func updateTransformersToDisplay() {
    let unsorted: [Transformer]
    switch mode {
    case .styles: unsorted = styles
    case .decorations: unsorted = decorations
    case .emoticons: unsorted = emoticons
    }

    let favorited = unsorted.filter { isFavorited(transformer: $0) }
    let unfavorited = unsorted.filter { !isFavorited(transformer: $0) }
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
