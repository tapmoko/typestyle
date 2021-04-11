import Foundation

let log = Log()

struct Log {

  func verbose(_ string: String) {
    print("📄 \(string)")
  }

  func debug(_ string: String) {
    print("👁 \(string)")
  }

  func info(_ string: String) {
    print("ℹ️ \(string)")
  }

  func warning(_ string: String) {
    print("⚠️ \(string)")
  }

  func error(_ string: String) {
    print("🚨 \(string)")
  }

}
