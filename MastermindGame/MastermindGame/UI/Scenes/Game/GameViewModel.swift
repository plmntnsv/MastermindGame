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
    var isGameRunning = false
    
    private(set) var secretLetters: [String] = []
    
    private var router: AppRouter
    private let timerService: TimerService
    private let gameService: GameServiceProtocol
    
    init(router: AppRouter, timerService: TimerService, gameService: GameServiceProtocol) {
        self.router = router
        self.timerService = timerService
        self.gameService = gameService
        self.secretCount = gameService.secretCount
        resetPlayerInputs()
    }
    
    func startGame() {
        guard !isGameRunning else { return }
        
        secretLetters = gameService.generateSecret()
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
        playerInput = gameService.validate(input: playerInput, against: secretLetters)
        
        if playerInput.allSatisfy({ $0.state == .correct }) {
            onGameEnd(isSuccess: true)
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
        
        router.push(.result(success: isSuccess, secret: secretLetters))
    }
}
