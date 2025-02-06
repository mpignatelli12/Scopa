//
//  Card.swift
//  Scopa
//
//  Created by Michael Pignatelli on 2/6/25.
//

import Foundation

enum Suit: String, CaseIterable {
    case coins = "Coins"
    case cups = "Cups"
    case swords = "Swords"
    case clubs = "Clubs"
}

enum Rank: Int, CaseIterable, CustomStringConvertible {
    case ace = 1
    case two, three, four, five, six, seven
    case jack = 8
    case knight = 9
    case king = 10

    public var description: String {
        switch self {
        case .ace:    return "Ace"
        case .two:    return "2"
        case .three:  return "3"
        case .four:   return "4"
        case .five:   return "5"
        case .six:    return "6"
        case .seven:  return "7"
        case .jack:   return "Jack"
        case .knight: return "Knight"
        case .king:   return "King"
        }
    }
}

struct Card: Identifiable, CustomStringConvertible {
    let id = UUID()
    let suit: Suit
    let rank: Rank
    
    var value: Int {
        return rank.rawValue
    }
    
    var description: String {
        return "\(rank.description) of \(suit.rawValue)"
    }
}
