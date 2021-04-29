import SwiftUI

struct GeneratorView: View {

  enum ViewMode {
    case generate
    case browse
  }

  @State var input = ""
  @State var viewMode: ViewMode = .generate

  // Determines if the output list should be displayed
  var showOutput: Bool {
    if viewMode == .generate && input.isEmpty {
      return false
    }

    return true
  }

  var transformerManager: TransformerManager

  // MARK: - Init

  init(transformerMode: TransformerManager.Mode) {
    transformerManager = TransformerManager(mode: transformerMode)

    // Browsing is the only view mode for emoticons
    if transformerMode == .emoticons { viewMode = .browse }
  }

  // MARK: - Body view

  var body: some View {
    VStack {
      inputEditor
        .layoutPriority(1)

      if showOutput {
        outputList
          .layoutPriority(2)
      }

      Spacer()
        .layoutPriority(1)
    }
    .background(Color.appBackground)
  }

  // MARK: - Other views

  var inputEditor: some View {
    InputViewRepresentable(input: $input, viewMode: $viewMode)
  }

  var outputList: some View {
    List {
      ForEach(transformerManager.transformerGroupingsToDisplay, id: \.groupName) { grouping in
        Section(header: Text(headerTextFor(grouping: grouping))) {
          ForEach(grouping.transformers, id: \.name) { transformer in
            Text(transformer.name)
          }
        }
      }
    }
  }

  // MARK: - Methods

  func headerTextFor(grouping: Transformer.Grouping) -> String {
    switch transformerManager.mode {
    case .styles, .decorations: return "no header"
    case .emoticons: return grouping.groupName
    }
  }

  func output(for indexPath: IndexPath) -> String {
    return transformerManager.transformedText(for: (viewMode == .generate) ? input : nil,
                                              indexPath: indexPath)
  }

}

struct GeneratorView_Previews: PreviewProvider {
  static var previews: some View {
    GeneratorView(transformerMode: .styles)
  }
}
