import Foundation

struct TransformerManager {

  enum Mode {
    case styles
    case decorations
    case emoticons
  }

  let mode: Mode

  let transformerGroupings: [Transformer.Grouping]
  var transformerGroupingsToDisplay: [Transformer.Grouping] = []

  init(mode: Mode) {
    self.mode = mode

    switch mode {
    case .styles: self.transformerGroupings = StyleFactory.allStyles()
    case .decorations: self.transformerGroupings = DecorationFactory.allDecorations()
    case .emoticons: self.transformerGroupings = EmoticonFactory.allEmoticons()
    }

    updateTransformersToDisplay()
  }

  mutating func updateTransformersToDisplay(filterInput: String? = nil) {
    let favorited: [Transformer.Grouping] = [(
      groupName: "Favorites",
      transformers: transformerGroupings.flatMap {
        $0.transformers.filter { isFavorited(transformer: $0) }
      }
    )]

    let unfavorited: [Transformer.Grouping] = transformerGroupings.map {
      (
        groupName: $0.groupName,
        transformers: $0.transformers.filter { !isFavorited(transformer: $0) }
      )
    }

    transformerGroupingsToDisplay = favorited + unfavorited

    if let filterInput = filterInput {
      if !filterInput.isEmpty {
        let lowercasedInput = filterInput.lowercased()

        transformerGroupingsToDisplay = transformerGroupingsToDisplay.map {
          (
            groupName: $0.groupName,
            transformers: $0.transformers.filter { $0.name.lowercased().contains(lowercasedInput) }
          )
        }
      }
    }
  }

}

// MARK: Favoriting

extension TransformerManager {

  func isFavorited(at indexPath: IndexPath) -> Bool {
    return isFavorited(transformer: transformerGroupingsToDisplay[indexPath.section].transformers[indexPath.row])
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
