import Foundation

struct Transformer {

  typealias Grouping = (groupName: String, transformers: [Transformer])

  let name: String
  let transform: (String) -> String

  init(name: String, outputBase: String, reverse: Bool = false) {
    self.name = name

    let inputBase = StyleTransformers.inputBase
    let transformerDictionary = Dictionary(uniqueKeysWithValues: zip(inputBase, outputBase))

    self.transform = { input in
      let string = String(input.map {
        transformerDictionary[$0] ?? $0
      })

      if reverse {
        return String(string.reversed())
      }
      
      return string
    }
  }

  init(name: String, before: String, after: String) {
    self.name = name
    self.transform = { (input) -> String in
      return "\(before) \(input) \(after)"
    }
  }
  
  init(name: String, transform: @escaping (String) -> String) {
    self.name = name
    self.transform = transform
  }

  init(name: String, output: String) {
    self.init(name: name, transform: { _ in output })
  }
}
