import SwiftUI

struct GeneratorView: View {

  enum ViewMode: String, CaseIterable {
    case generate = "Generate"
    case browse = "Browse"
  }

  @State var input = ""
  @State var isInputFocused = false
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
    ZStack {
      Rectangle()
        .fill(Theme.appBackground)
        .edgesIgnoringSafeArea(.all)

      VStack {
        inputView

        outputList

        viewModeSegmentedControl
      }
    }
  }

  // MARK: - Other views

  var inputView: some View {
    HStack {
      InputViewRepresentable(
        input: $input,
        isInputFocused: $isInputFocused,
        viewMode: $viewMode
      )
      .padding(Theme.spacing)

      if !input.isEmpty {
        clearButton
          .padding(.trailing, Theme.spacing)
      }
    }
    .background(Theme.appDarkBackground)
    .cornerRadius(Theme.spacing)
    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 0)
    .padding(Theme.spacing)
  }

  var clearButton: some View {
    Button(action: {
      isInputFocused = false
      input = ""
    }) {
      Image(systemName: "xmark")
        .foregroundColor(Theme.appText)
        .font(.title3.bold())
    }
  }

  var outputList: some View {
    ObservableScrollView(
      axes: [.vertical],
      showsIndicators: true,
      offsetChanged: { _ in isInputFocused = false }
    ) {
      if showOutput {
        ForEach(transformerManager.transformerGroupingsToDisplay, id: \.groupName) { grouping in
          LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
            if let header = headerTextFor(grouping: grouping) {
              Section(header: Text(header)) {
                ForEach(grouping.transformers, id: \.name) { transformer in
                  OutputRow(output: output(for: input, with: transformer))
                }
              }
            } else {
              ForEach(grouping.transformers, id: \.name) { transformer in
                OutputRow(output: output(for: input, with: transformer))
              }
            }
          }
        }
      }
    }
  }

  var viewModeSegmentedControl: some View {
    Picker("", selection: $viewMode) {
      Text(ViewMode.generate.rawValue).tag(ViewMode.generate)
      Text(ViewMode.browse.rawValue).tag(ViewMode.browse)
    }
    .pickerStyle(SegmentedPickerStyle())
    .padding(Theme.spacing)
  }

  // MARK: - Methods

  func headerTextFor(grouping: Transformer.Grouping) -> String? {
    switch transformerManager.mode {
    case .styles, .decorations: return nil
    case .emoticons: return grouping.groupName
    }
  }

  func output(for text: String?, with transformer: Transformer) -> String {
    return transformer.transform(text ?? transformer.name)
  }

}

struct GeneratorView_Previews: PreviewProvider {
  static var previews: some View {
    GeneratorView(transformerMode: .styles)
  }
}
