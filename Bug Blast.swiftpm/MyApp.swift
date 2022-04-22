import SwiftUI
@main

struct MyApp: App {
    var body: some Scene {
        let backgroundPlayer = MusicPlayer(audioName: "spacejam", volume: 0.3, fileType: "mp3", playInfinite: true)
        WindowGroup {
            ContentView()
                .onAppear {
                    backgroundPlayer.play()
                }
        }
    }
}
