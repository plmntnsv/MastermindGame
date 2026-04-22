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
    var remainingTime: Int = 60
    let totalTime = 60
    var playerInput: [InputSlot] = []
    let secretCount: Int
    
    private(set) var isGameRunning = false
    private(set) var secretLetters: [String] = []
    
    private let characters: [String] = (65...90).map { String(UnicodeScalar($0)) } // A to Z
    
    private var router: AppRouter
    private let timerService: TimerService
    
    init(router: AppRouter, timerService: TimerService, secretCount: Int = 4) {
        self.router = router
        self.timerService = timerService
        self.secretCount = secretCount
        resetPlayerInputs()
    }
    
    func startGame() {
        guard !isGameRunning else { return }
        
        secretLetters = (0..<secretCount).map { _ in characters.randomElement()! }
        resetPlayerInputs()
        
        print(secretLetters)
        
        isGameRunning = true
        
        timerService.start(duration: self.remainingTime) { [weak self] remainingTime in
            self?.remainingTime = remainingTime
        } completion: { [weak self] in
            self?.onGameEnd(isSuccess: false)
        }
    }
    
    func onCheckTapped() {
        var secretCopy = secretLetters
        
        for index in 0..<secretCount {
            let letter = playerInput[index].text
            
            if letter == secretCopy[index] {
                playerInput[index].state = .correct
                secretCopy[index] = ""
            } else {
                playerInput[index].state = .wrong
            }
        }
        
        for index in 0..<secretCount {
            if playerInput[index].state == .correct {
                continue
            }
            
            let letter = playerInput[index].text
            
            if secretCopy.contains(letter) && !letter.isEmpty {
                playerInput[index].state = .misplaced
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
    
    private func resetPlayerInputs() {
        playerInput = (0..<secretCount).map { _ in .init() }
    }
    
    private func onGameEnd(isSuccess: Bool) {
        isGameRunning = false
        
        timerService.stop()
        remainingTime = totalTime
        
        router.push(.result(success: isSuccess))
    }
}
