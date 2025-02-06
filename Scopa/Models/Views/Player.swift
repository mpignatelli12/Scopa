//
//  Player.swift
//  Scopa
//
//  Created by Michael Pignatelli on 2/6/25.
//


import Foundation

class Player: Identifiable, ObservableObject {
    let id = UUID()
    let name: String
    @Published var hand: [Card] = []
    @Published var capturedCards: [Card] = []
    
    init(name: String) {
        self.name = name
    }
    
    /// Add cards to the capture pile.
    func capture(cards: [Card]) {
        capturedCards.append(contentsOf: cards)
    }
}
