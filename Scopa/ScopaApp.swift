import SwiftUI

@main
struct ScopaApp: App {
    var body: some Scene {
        WindowGroup {
            // Create game instance with one human ("You") and one automated ("Computer") player.
            ContentView(game: Game(playerNames: ["You", "Computer"]))
        }
    }
}