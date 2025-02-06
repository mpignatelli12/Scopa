import SwiftUI

struct ContentView: View {
    @ObservedObject var game: Game
    var body: some View {
        NavigationView {
            GameBoardView(game: game)
                .navigationTitle("Scopa")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: Game(playerNames: ["You", "Computer"]))
    }
}