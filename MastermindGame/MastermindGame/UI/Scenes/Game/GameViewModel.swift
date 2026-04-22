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
    
    private(set) var targetLetters: [String] = []
    private let characters: [String] = (65...90).map { String(UnicodeScalar($0)) } // A to Z
    
    init(router: AppRouter, textCount: Int = 4) {
        self.router = router
        self.textCount = textCount
        playerInput = (0..<textCount).map { _ in .init(text: "", state: .empty) }
    }
    
    func generateTargetText() {
        targetLetters = (0..<textCount).map { _ in characters.randomElement()! }
        
        print(targetLetters)
    }
    
    func onCheckTapped() {
        var targetCopy = targetLetters
        
        for index in 0..<textCount {
            let letter = playerInput[index].text
            
            if letter == targetCopy[index] {
                playerInput[index].state = .correct
                targetCopy[index] = ""
            } else {
                playerInput[index].state = .wrong
            }
        }
        
        for index in 0..<textCount {
            if playerInput[index].state == .correct {
                continue
            }
            
            let letter = playerInput[index].text
            
            if targetCopy.contains(letter) && !letter.isEmpty {
                playerInput[index].state = .misplaced
            }
        }
        
        print(targetCopy)
        print(targetLetters)
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
