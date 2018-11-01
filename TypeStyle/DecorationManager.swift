import Foundation

struct DecorationManager {

  static let shared = DecorationManager()

  let decorations: [Decoration] = [
    Decoration(name: "Decoration 1", prepend: "★·.·´¯`·.·★", append: "★·.·´¯`·.·★"),
    Decoration(name: "Decoration 2", prepend: "▁ ▂ ▄ ▅ ▆ ▇ █", append: "█ ▇ ▆ ▅ ▄ ▂ ▁"),
    Decoration(name: "Decoration 3", prepend: "°°°·.°·..·°¯°·._.·", append: "·._.·°¯°·.·° .·°°°"),
    Decoration(name: "Decoration 4", prepend: "¸,ø¤º°`°º¤ø,¸¸,ø¤º°", append: "°º¤ø,¸¸,ø¤º°`°º¤ø,¸"),
    Decoration(name: "Decoration 5", prepend: "ıllıllı", append: "ıllıllı"),
    Decoration(name: "Decoration 6", prepend: "•?((¯°·._.•", append: "•._.·°¯))؟•"),
    Decoration(name: "Decoration 7", prepend: "▌│█║▌║▌║", append: "║▌║▌║█│▌"),
  ]

  func decoratedText(forText text: String, rowIndex: Int) -> String {
    let newDecoration = decorations[rowIndex]
    return "\(newDecoration.prepend) \(text) \(newDecoration.append)"
  }

}
