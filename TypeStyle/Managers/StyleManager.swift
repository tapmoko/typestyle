import Foundation

struct StyleManager {

  static let shared = StyleManager()

  let inputBase = StyleFactory.inputBase()
  let styles = StyleFactory.allStyles()

  func styledText(for text: String, index: Int) -> String {
    let newStyle = styles[index].outputBase
    let convert = Dictionary(uniqueKeysWithValues: zip(inputBase, newStyle))

    let newText = String(text.map {
      convert[$0] ?? $0
    })

    return newText
  }

}
