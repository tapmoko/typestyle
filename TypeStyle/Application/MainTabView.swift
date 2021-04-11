import SwiftUI

struct MainTabView: View {
  var body: some View {
    TabView {
      Text("Styles page")
        .tabItem {
          Label("Styles", systemImage: "bold.italic.underline")
        }

      Text("Decorations page")
        .tabItem {
          Label("Decorations", systemImage: "wand.and.stars")
        }

      Text("Emoticons page")
        .tabItem {
          Label("Emoticons", systemImage: "smiley")
        }

      Text("About page")
        .tabItem {
          Label("About", systemImage: "info.circle")
        }
    }
  }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView()
  }
}
