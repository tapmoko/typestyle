import SwiftUI

struct OutputRow: View {

  let output: String

  // MARK: - Body view

  var body: some View {
    HStack(spacing: Theme.spacing) {
      Text(output)
        .foregroundColor(.appText)

      Spacer(minLength: 0)
    }
    .padding(Theme.spacing)
    .listRowBackground(Color.clear)
  }
}

struct OutputRow_Previews: PreviewProvider {
  static var previews: some View {
    OutputRow(output: "Hello World")
      .background(Color.appBackground)
      .previewLayout(.sizeThatFits)
  }
}
