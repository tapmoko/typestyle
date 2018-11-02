import Foundation

struct StyleManager {

  static let shared = StyleManager()

  let inputBase = StyleFactory.inputBase()
  let styles = StyleFactory.allStyles()

  func styledText(for text: String, index: Int) -> String {
    let style = styles[index]
    return style.transform(text)
  }

}
