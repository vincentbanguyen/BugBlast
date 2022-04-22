import SwiftUI

let screenHeight = UIDevice.current.orientation.isLandscape ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
let screenWidth = UIDevice.current.orientation.isLandscape ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height

struct ContentView: View {
    
    @StateObject var viewRouter = ViewRouter()
    
    
    var body: some View {
        ZStack {
            
            switch viewRouter.currentScreen {
                
            case Screen.preGame:
                PreGame()
                    .environmentObject(viewRouter)
                
            case Screen.Game:
                GameView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 45) {
                            viewRouter.currentScreen = .postGame
                        }
                    }
                    .environmentObject(viewRouter)
                
            case Screen.postGame:
                PostGame()
                    .environmentObject(viewRouter)
            }
        }
    }
}
