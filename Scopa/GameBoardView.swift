import SwiftUI

struct GameBoardView: View {
    @ObservedObject var game: Game
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Table Cards")
                .font(.headline)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(game.tableCards) { card in
                        CardView(card: card)
                    }
                }
            }
            
            Divider()
            
            // Display the human player's hand.
            if let humanPlayer = game.players.first(where: { $0.name == "You" }) {
                Text("Your Hand")
                    .font(.headline)
                HStack {
                    ForEach(humanPlayer.hand) { card in
                        Button(action: {
                            // For demonstration, if there is any table card with equal value, capture it.
                            if let tableCard = game.tableCards.first(where: { $0.value == card.value }) {
                                let valid = game.playTurn(player: humanPlayer, playedCard: card, selectedTableCards: [tableCard])
                                if !valid {
                                    // (Optional) Handle invalid move (e.g. show an alert).
                                }
                            } else {
                                // Otherwise, play the card to the table.
                                if let index = humanPlayer.hand.firstIndex(where: { $0.id == card.id }) {
                                    humanPlayer.hand.remove(at: index)
                                }
                                game.tableCards.append(card)
                                game.nextTurn()
                            }
                        }) {
                            CardView(card: card)
                        }
                    }
                }
            }
            
            Divider()
            
            // Display each player's captured cards count.
            List(game.players) { player in
                HStack {
                    Text(player.name)
                    Spacer()
                    Text("Captured: \(player.capturedCards.count)")
                }
            }
        }
        .padding()
        .onAppear(perform: checkForAIMove)
    }
    
    /// Checks whether it is the AI’s turn and performs an AI move if needed.
    func checkForAIMove() {
        // If the current player is not "You" (i.e. is AI) and has cards, perform AI move after a short delay.
        let currentPlayer = game.players[game.currentPlayerIndex]
        if currentPlayer.name != "You" && !currentPlayer.hand.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                game.aiPlay(for: currentPlayer)
                // Continue checking recursively if next player is also an AI.
                checkForAIMove()
            }
        }
    }
}