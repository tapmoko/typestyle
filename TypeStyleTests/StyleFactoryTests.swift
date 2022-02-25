import XCTest
@testable import TypeStyle

class StyleTransformersTests: XCTestCase {

  func testAllStyles() {
    let styles = StyleTransformers.allStyles()

    XCTAssertFalse(styles.isEmpty)
  }

}
