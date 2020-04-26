import Foundation

struct EmoticonFactory {

  static func allEmoticons() -> [Transformer] {
    return [
      Transformer(name: "Emoticon 1", output: ":)")
    ]
  }

}
