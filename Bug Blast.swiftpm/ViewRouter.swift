import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentScreen: Screen = .preGame
}

enum Screen {
    case preGame
    case Game
    case postGame
}
