import SwiftUI

struct MultiplayerGameView: View {
    @ObservedObject var multiplayer = MultiplayerManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Multiplayer Scopa")
                .font(.largeTitle)
                .padding(.top)
            
            Text("Current Game State:")
                .font(.headline)
            Text(multiplayer.gameState.tableCards.isEmpty ? "Table is empty" : "\(multiplayer.gameState.tableCards.map { $0.description }.joined(separator: ", "))")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            Button("Find Match") {
                multiplayer.findMatch()
            }
            .padding()
            
            Button("Take Turn (Simulated Update)") {
                // For demonstration purposes, update the state.
                // In a full game, you would apply the move logic to update the game state.
                var newState = multiplayer.gameState
                // For example, add a dummy card to the table.
                let dummyCard = Card(suit: .clubs, rank: .ace)
                newState.tableCards.append(dummyCard)
                // Rotate turn.
                newState.currentPlayerIndex = (newState.currentPlayerIndex + 1) % max(1, newState.players.count)
                multiplayer.takeTurn(with: newState)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

struct MultiplayerGameView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerGameView()
    }
}