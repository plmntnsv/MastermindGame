//
//  GameViewModel.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import Foundation
import SwiftUI


struct InputSlot {
    var text: String
    var state: SlotState
    
    enum SlotState {
        case empty
        case correct
        case misplaced
        case wrong
        
        var color: Color {
            switch self {
            case .empty:
                return .clear
            case .correct:
                return .green
            case .misplaced:
                return .orange
            case .wrong:
                return .red
            }
        }
    }
}

@Observable
final class GameViewModel {
    var router: AppRouter
    let textCount: Int
    
    var playerInput: [InputSlot]
    
    private(set) var targetText: [String] = []
    private let characters: [String] = (65...90).map { String(UnicodeScalar($0)) } // A to Z
    
    init(router: AppRouter, textCount: Int = 4) {
        self.router = router
        self.textCount = textCount
        playerInput = (0..<textCount).map { _ in .init(text: "", state: .empty) }
    }
    
    func generateTargetText() {
        targetText = (0..<textCount).map { _ in characters.randomElement()! }
        
        print(targetText)
    }
    
    func onCheckTapped() {
        for index in playerInput.indices {
            if playerInput[index].text == targetText[index] {
                playerInput[index].state = .correct
            } else if targetText.contains(playerInput[index].text) {
                playerInput[index].state = .misplaced
            } else {
                playerInput[index].state = .wrong
            }
        }
    }
    
    private func onGameEnd(isSuccess: Bool) {
        router.push(.result(success: isSuccess))
    }
}
