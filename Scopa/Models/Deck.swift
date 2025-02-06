//
//  Deck.swift
//  Scopa
//
//  Created by Michael Pignatelli on 2/6/25.
//

import Foundation

struct Deck {
    private(set) var cards: [Card] = []
    
    init() {
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                cards.append(Card(suit: suit, rank: rank))
            }
        }
        shuffle()
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func draw() -> Card? {
        guard !cards.isEmpty else { return nil }
        return cards.removeLast()
    }
}
