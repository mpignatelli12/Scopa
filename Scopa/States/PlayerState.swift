//
//  PlayerState.swift
//  Scopa
//
//  Created by Michael Pignatelli on 2/21/25.
//


import Foundation

struct PlayerState: Codable {
    let name: String
    let hand: [Card]
    let capturedCards: [Card]
}