import Foundation

struct CustomTransforms {

  static let mockingSpongeBob: (String) -> String = { input in
    let lowercaseInput = input.lowercased()
    let transformableChars = "abcdefghijklmnopqrstuvwxyz"
    var output = ""
    var makeNextUppercase = true

    for char in lowercaseInput {
      guard transformableChars.contains(char) else {
        output.append(char)
        continue
      }

      output.append(makeNextUppercase ? String(char).uppercased().first ?? char : char)
      makeNextUppercase.toggle()
    }
    return output
  }

}
