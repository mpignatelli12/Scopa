import Foundation

struct PlayerState: Codable {
    let name: String
    let hand: [Card]
    let capturedCards: [Card]
}