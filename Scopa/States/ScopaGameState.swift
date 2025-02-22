import Foundation

struct ScopaGameState: Codable {
    let tableCards: [Card]
    let players: [PlayerState]
    let currentPlayerIndex: Int
}