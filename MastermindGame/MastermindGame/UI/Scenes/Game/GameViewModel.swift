//
//  GameViewModel.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import Foundation
import SwiftUI


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
        // TODO: mark letter as wrong if already matched
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
    
    func colorForInputSlot(at index: Int) -> Color {
        guard index >= 0 && index < playerInput.count else {
            return .white
        }
        
        let state = playerInput[index].state
        switch state {
        case .empty:
            return .white
        case .correct:
            return .green
        case .misplaced:
            return .orange
        case .wrong:
            return .red
        }
    }
    
    private func onGameEnd(isSuccess: Bool) {
        router.push(.result(success: isSuccess))
    }
}
