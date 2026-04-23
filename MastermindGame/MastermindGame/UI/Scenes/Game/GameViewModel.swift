//
//  GameViewModel.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import Foundation
import SwiftUI

protocol GameViewModelType: AnyObject {
    var secretLength: Int { get }
    var totalTime: Int { get }
    var remainingTime: Int { get set }
    var playerInput: [String] { get set }
    var error: GameError? { get set }
    var debugSecretLetters: [Character] { get }
    var isGameRunning: Bool { get }
    
    func startGame()
    func onCheckTapped()
    func colorForInputBox(at index: Int) -> Color
}

@Observable
final class GameViewModel: GameViewModelType {
    let secretLength = AppConstant.lettersCount
    let totalTime = AppConstant.gameTotalTime
    var remainingTime = AppConstant.gameTotalTime
    var playerInput: [String] = []
    var error: GameError?
    
    // added this for faster testing purposes
    var debugSecretLetters: [Character] { secretLetters }
    
    private(set) var isGameRunning = false
    private var secretLetters: [Character] = []
    private var inputBoxState: [InputBoxState] = []
    
    private var router: AppRouting
    private let timerService: TimerService
    private let gameService: GameServiceProtocol
    
    init(router: AppRouting, timerService: TimerService, gameService: GameServiceProtocol) {
        self.router = router
        self.timerService = timerService
        self.gameService = gameService
        resetPlayerInputs()
    }
    
    func startGame() {
        guard !isGameRunning else { return }
        
        switch gameService.generateSecret(length: secretLength) {
        case .success(let secret):
            secretLetters = secret
        case .failure(let error):
            self.error = error
            return
        }
        
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
        guard playerInput.allSatisfy({ !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) else {
            return
        }
        
        guard playerInput.allSatisfy({ $0.count == 1  }) else {
            error = .invalidInputLength
            return
        }
        
        let input = playerInput.map { Character($0) }
        
        switch gameService.validate(input: input, against: secretLetters) {
        case .success(let validatedInput):
            validatedInput.enumerated().forEach { index, result in
                playerInput[index] = String(result.letter)
                inputBoxState[index] = result.state
            }
        case .failure(let error):
            self.error = error
            return
        }
        
        if inputBoxState.allSatisfy({ $0 == .correct }) {
            onGameEnd(isSuccess: true)
        }
    }
    
    func colorForInputBox(at index: Int) -> Color {
        guard index >= 0 && index < playerInput.count else {
            return .white
        }
        
        switch inputBoxState[index] {
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
        playerInput = (0..<secretLength).map { _ in "" }
        inputBoxState = (0..<secretLength).map { _ in .empty }
    }
    
    private func onGameEnd(isSuccess: Bool) {
        isGameRunning = false
        
        timerService.stop()
        remainingTime = totalTime
        
        router.push(.result(success: isSuccess, secret: secretLetters))
    }
}
