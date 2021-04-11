import SwiftUI

@main
struct TypeStyleApp: App {

  @Environment(\.scenePhase) private var scenePhase

  @State var isInitialDidBecomeActive = true

  var body: some Scene {
    WindowGroup {
      MainTabView()
        .onChange(of: scenePhase) { handle(scenePhase: $0) }
    }
  }

  private func handle(scenePhase: ScenePhase) {
    switch scenePhase {
    case .active: didBecomeActive()
    case .inactive: didBecomeInactive()
    case .background: didEnterBackground()
    @unknown default: break
    }
  }

  // The scene is in the foreground and interactive.
  private func didBecomeActive() {
    if !isInitialDidBecomeActive { return }

    Products.store.requestProducts { success, tipProducts in
      if success {
        Products.tipProducts = tipProducts!
      }
    }

    isInitialDidBecomeActive = false
  }

  // The scene is in the foreground but should pause its work.
  private func didBecomeInactive() {
  }

  // The scene isn’t currently visible in the UI.
  private func didEnterBackground() {
  }

}
