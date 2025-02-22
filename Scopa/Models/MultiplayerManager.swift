import Foundation
import GameKit
import SwiftUI

class MultiplayerManager: NSObject, ObservableObject {
    static let shared = MultiplayerManager()
    
    // The current match
    @Published var currentMatch: GKTurnBasedMatch?
    
    // A simple example game state; in a real game, serialize your full game state.
    @Published var gameState: String = "initial state"
    
    override init() {
        super.init()
        authenticateLocalPlayer()
    }
    
    // MARK: - Authentication
    private func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { vc, error in
            if let vc = vc {
                // Present the Game Center login view.
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootVC = windowScene.windows.first?.rootViewController {
                    rootVC.present(vc, animated: true)
                }
            } else if localPlayer.isAuthenticated {
                // Successful authentication.
                localPlayer.register(self)
                print("Player authenticated: \(localPlayer.displayName)")
            } else {
                print("Player not authenticated")
                if let error = error { print("Error: \(error.localizedDescription)") }
            }
        }
    }
    
    // MARK: - Matchmaking
    func findMatch(minPlayers: Int = 2, maxPlayers: Int = 4) {
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        
        guard let vc = GKTurnBasedMatchmakerViewController(matchRequest: request) else { return }
        vc.turnBasedMatchmakerDelegate = self
        
        // Present the matchmaking view controller.
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(vc, animated: true)
        }
    }
    
    // Call this method when you want to update the match's game state.
    func updateMatchState(with newState: String) {
        gameState = newState
        guard let match = currentMatch else { return }
        
        // In a real game, you would encode your game state (e.g. to JSON data).
        if let stateData = newState.data(using: .utf8) {
            match.endTurn(withNextParticipants: match.participants, turnTimeout: GKTurnTimeoutDefault, match: stateData) { error in
                if let error = error {
                    print("Error ending turn: \(error.localizedDescription)")
                } else {
                    print("Turn ended successfully.")
                }
            }
        }
    }
    
    // Call this method to take a turn (for example, after a move is made).
    func takeTurn() {
        // Update your game state accordingly.
        let newState = "state updated at \(Date())"
        updateMatchState(with: newState)
    }
    
    // Handle receiving an updated match.
    func handleUpdatedMatch(_ match: GKTurnBasedMatch) {
        currentMatch = match
        if let matchData = match.matchData, let stateString = String(data: matchData, encoding: .utf8) {
            gameState = stateString
            print("Received updated match state: \(stateString)")
        }
    }
}

// MARK: - GKTurnBasedMatchmakerViewControllerDelegate
extension MultiplayerManager: GKTurnBasedMatchmakerViewControllerDelegate {
    func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true)
        print("Matchmaker error: \(error.localizedDescription)")
    }
    
    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFind match: GKTurnBasedMatch) {
        viewController.dismiss(animated: true)
        currentMatch = match
        // If the match has existing data, update the local game state.
        if let matchData = match.matchData, let stateString = String(data: matchData, encoding: .utf8) {
            gameState = stateString
        }
        print("Match found with participants: \(match.participants.map { $0.player?.displayName ?? "unknown" })")
    }
}

// MARK: - GKLocalPlayerListener
extension MultiplayerManager: GKLocalPlayerListener {
    // Called when the match data changes.
    func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
        print("Turn event received.")
        handleUpdatedMatch(match)
    }
    
    // You can implement additional listener methods to handle match removals, invites, etc.
}