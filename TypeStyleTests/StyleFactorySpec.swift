import Quick
import Nimble
import TypeStyle

class StyleFactorySpec: QuickSpec {

  override func spec() {
    let styles = StyleFactory.allStyles()

    expect(styles).toNot(beEmpty())
  }

}
