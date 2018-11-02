import Foundation

struct Transformer {

  let name: String
  let transform: (String) -> String

  init(name: String, outputBase: String) {
    self.name = name

    let inputBase = StyleFactory.inputBase()
    let transformerDictionary = Dictionary(uniqueKeysWithValues: zip(inputBase, outputBase))

    self.transform = { (input) -> String in
      return String(input.map {
        transformerDictionary[$0] ?? $0
      })
    }
  }

  init(name: String, before: String, after: String) {
    self.name = name
    self.transform = { (input) -> String in
      return "\(before) \(input) \(after)"
    }
  }

}
