import SwiftUI

struct MainTabView: View {
  var body: some View {
    TabView {
      GeneratorView(transformerMode: .styles)
        .tabItem {
          Label("Styles", systemImage: "bold.italic.underline")
        }

      GeneratorView(transformerMode: .decorations)
        .tabItem {
          Label("Decorations", systemImage: "wand.and.stars")
        }

      GeneratorView(transformerMode: .emoticons)
        .tabItem {
          Label("Emoticons", systemImage: "smiley")
        }

      Text("About page")
        .tabItem {
          Label("About", systemImage: "info.circle")
        }
    }
    .background(Color.appBackground)
  }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView()
  }
}
