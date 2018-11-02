import Foundation

struct Transformation {

  let name: String
  let transformer: (String) -> String

  init(name: String, outputBase: String) {
    self.name = name

    let inputBase = StyleFactory.inputBase()
    let transformerDictionary = Dictionary(uniqueKeysWithValues: zip(inputBase, outputBase))

    self.transformer = { (input) -> String in
      return String(input.map {
        transformerDictionary[$0] ?? $0
      })
    }
  }

  init(name: String, before: String, after: String) {
    self.name = name
    self.transformer = { (input) -> String in
      return "\(before) \(input) \(after)"
    }
  }

}
