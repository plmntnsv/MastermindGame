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
    var remainingTime = 60
    let totalTime = 60
    var playerInput: [InputBox] = []
    let secretLength = 4
    
    private(set) var isGameRunning = false
    private var secretLetters: [String] = []
    
    // added this for faster testing purposes
    var debugSecretLetters: [String] { secretLetters }
    
    private var router: AppRouter
    private let timerService: TimerService
    private let gameService: GameServiceProtocol
    
    init(router: AppRouter, timerService: TimerService, gameService: GameServiceProtocol) {
        self.router = router
        self.timerService = timerService
        self.gameService = gameService
        resetPlayerInputs()
    }
    
    func startGame() {
        guard !isGameRunning else { return }
        
        secretLetters = gameService.generateSecret(length: secretLength)
        resetPlayerInputs()
        
        print(secretLetters)
        
        isGameRunning = true
        
        timerService.start(duration: self.remainingTime) { [weak self] remainingTime in
            self?.remainingTime = max(remainingTime, 0)
        } completion: { [weak self] in
            self?.onGameEnd(isSuccess: false)
        }
    }
    
    func onCheckTapped() {
        guard playerInput.allSatisfy({ !$0.text.isEmpty }) else {
            return
        }
        
        playerInput = gameService.validate(input: playerInput, against: secretLetters)
        
        if playerInput.allSatisfy({ $0.state == .correct }) {
            onGameEnd(isSuccess: true)
        }
    }
    
    func colorForInputBox(at index: Int) -> Color {
        guard index >= 0 && index < playerInput.count else {
            return .white
        }
        
        switch playerInput[index].state {
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
        playerInput = (0..<secretLength).map { _ in .init() }
    }
    
    private func onGameEnd(isSuccess: Bool) {
        isGameRunning = false
        
        timerService.stop()
        remainingTime = totalTime
        
        router.push(.result(success: isSuccess, secret: secretLetters))
    }
}
