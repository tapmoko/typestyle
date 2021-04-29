import SwiftUI

struct GeneratorView: View {

  enum ViewMode: String, CaseIterable {
    case generate = "Generate"
    case browse = "Browse"
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
      inputView

      outputList

      viewModeSegmentedControl
    }
    .background(Color.appBackground)
  }

  // MARK: - Other views

  var inputView: some View {
    HStack {
      InputViewRepresentable(input: $input, viewMode: $viewMode)
        .padding(10)

      if !input.isEmpty {
        clearButton
          .padding(.trailing, 10)
      }
    }
    .background(Color.appDarkBackground)
    .cornerRadius(10)
    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 0)
    .padding(10)
  }

  var clearButton: some View {
    Button(action: {
      input = ""
    }) {
      Image(systemName: "xmark")
        .foregroundColor(.appText)
        .font(.title2.bold())
    }
  }

  var outputList: some View {
    List {
      if showOutput {
        ForEach(transformerManager.transformerGroupingsToDisplay, id: \.groupName) { grouping in
          if let header = headerTextFor(grouping: grouping) {
            Section(header: Text(header)) {
              ForEach(grouping.transformers, id: \.name) { transformer in
                Text(output(for: input, with: transformer))
                  .listRowBackground(Color.clear)
              }
            }
          } else {
            ForEach(grouping.transformers, id: \.name) { transformer in
              Text(output(for: input, with: transformer))
                .listRowBackground(Color.clear)
            }
          }
        }
      }
    }
    .background(Color.appBackground)
  }

  var viewModeSegmentedControl: some View {
    Picker("", selection: $viewMode) {
      Text(ViewMode.generate.rawValue).tag(ViewMode.generate)
      Text(ViewMode.browse.rawValue).tag(ViewMode.browse)
    }
    .pickerStyle(SegmentedPickerStyle())
    .padding(10)
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
