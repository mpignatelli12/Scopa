//
//  Game.swift
//  Scopa
//
//  Created by Michael Pignatelli on 2/6/25.
//


import Foundation

class Game: ObservableObject {
    @Published var deck: Deck
    @Published var tableCards: [Card] = []
    @Published var players: [Player] = []
    @Published var currentPlayerIndex: Int = 0
    
    init(playerNames: [String]) {
        self.deck = Deck()
        for name in playerNames {
            let player = Player(name: name)
            players.append(player)
        }
        // Deal 4 cards on the table at the start.
        for _ in 0..<4 {
            if let card = deck.draw() {
                tableCards.append(card)
            }
        }
        // Deal the initial hands (3 cards per player).
        dealHands()
    }
    
    /// Deal 3 cards to each player.
    func dealHands() {
        for player in players {
            player.hand = []
            for _ in 0..<3 {
                if let card = deck.draw() {
                    player.hand.append(card)
                }
            }
        }
    }
    
    /// Advances the turn and deals new hands when needed.
    func nextTurn() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        if players.allSatisfy({ $0.hand.isEmpty }) && !deck.cards.isEmpty {
            dealHands()
        }
    }
    
    /// Processes a player's move.
    ///
    /// - Parameters:
    ///   - player: The player making the move.
    ///   - playedCard: The card played from hand.
    ///   - selectedTableCards: The table cards the player wishes to capture.
    /// - Returns: A Boolean indicating whether the move was valid.
    func playTurn(player: Player, playedCard: Card, selectedTableCards: [Card]) -> Bool {
        // Validate: the sum of the selected cards must equal the played card's value.
        let sum = selectedTableCards.reduce(0) { $0 + $1.value }
        guard sum == playedCard.value else { return false }
        
        // Remove selected cards from the table.
        for card in selectedTableCards {
            if let index = tableCards.firstIndex(where: { $0.id == card.id }) {
                tableCards.remove(at: index)
            }
        }
        
        // Add the played card and the captured table cards to the player's capture pile.
        player.capture(cards: [playedCard] + selectedTableCards)
        
        // Remove the played card from the player's hand.
        if let index = player.hand.firstIndex(where: { $0.id == playedCard.id }) {
            player.hand.remove(at: index)
        }
        
        // (Optional) Detect if the table was cleared for a "scopa" (bonus point).
        // You can record this event as needed.
        
        nextTurn()
        return true
    }
    
    /// A simple AI move for an automated player.
    func aiPlay(for player: Player) {
        guard let cardToPlay = player.hand.first else { return }
        
        // Look for a capture: try to match any single table card.
        if let tableCard = tableCards.first(where: { $0.value == cardToPlay.value }) {
            _ = playTurn(player: player, playedCard: cardToPlay, selectedTableCards: [tableCard])
        } else {
            // If no capture is possible, simply "drop" the card on the table.
            if let index = player.hand.firstIndex(where: { $0.id == cardToPlay.id }) {
                player.hand.remove(at: index)
            }
            tableCards.append(cardToPlay)
            nextTurn()
        }
    }
}