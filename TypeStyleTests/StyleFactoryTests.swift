import XCTest
@testable import TypeStyle

class StyleFactoryTests: XCTestCase {

  func testAllStyles() {
    let styles = StyleFactory.allStyles()

    XCTAssertFalse(styles.isEmpty)
  }

}
