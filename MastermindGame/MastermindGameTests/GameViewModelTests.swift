//
//  GameViewModelTests.swift
//  MastermindGameTests
//
//  Created by Plamen Atanasov on 20.04.26.
//

import Testing
import SwiftUI
@testable import MastermindGame

@Suite("GameViewModel")
@MainActor
struct GameViewModelTests {
    @Test("startGame - initializes state and starts timer, resets player inputs")
    func testStartGame() async throws {
        let router = AppRouterMock()
        let timerService = TimerServiceMock()
        let gameService = GameServiceMock()
        let vm = GameViewModel(router: router, timerService: timerService, gameService: gameService)
        
        #expect(vm.playerInput.count == vm.secretLength)
        #expect(vm.isGameRunning == false)
        #expect(vm.remainingTime == vm.totalTime)
        
        vm.playerInput = [
            InputBox(text: "A", state: .wrong),
            InputBox(text: "A", state: .wrong),
            InputBox(text: "A", state: .wrong),
            InputBox(text: "A", state: .wrong)]
        
        vm.startGame()
        
        #expect(vm.isGameRunning == true)
        #expect(timerService.startDuration == vm.remainingTime)
        #expect(vm.playerInput.count == vm.secretLength)
        #expect(vm.playerInput.allSatisfy { $0.text.isEmpty && $0.state == .empty })
    }
    
    @Test("on timer tick - updates remaining time, completion ends game and navigates to failed result")
    func testTimerTickAndCompletion() async throws {
        let router = AppRouterMock()
        let timerService = TimerServiceMock()
        let gameService = GameServiceMock()
        let vm = GameViewModel(router: router, timerService: timerService, gameService: gameService)
        
        vm.startGame()
        #expect(vm.isGameRunning == true)
        
        timerService.sendTick(30)
        #expect(vm.remainingTime == 30)
        
        timerService.finish()
        #expect(vm.isGameRunning == false)
        #expect(vm.remainingTime == vm.totalTime)
        
        // Router should have pushed a result route with success false
        #expect(router.pushedRoutes.count == 1)
        if case let .result(success, secret) = router.pushedRoutes.first! {
            #expect(success == false)
            #expect(secret == gameService.secretMock)
        } else {
            Issue.record("Unexpected result route")
        }
    }
    
    @Test("onCheckTapped - does nothing when inputs incomplete")
    func testOnCheckTappedIncomplete() async throws {
        let router = AppRouterMock()
        let timerService = TimerServiceMock()
        let gameService = GameServiceMock()
        let vm = GameViewModel(router: router, timerService: timerService, gameService: gameService)
        
        vm.startGame()
        vm.onCheckTapped()
        
        #expect(router.pushedRoutes.isEmpty)
    }
    
    @Test("onCheckTapped - triggers success when all correct")
    func testOnCheckTappedSuccess() async throws {
        let router = AppRouterMock()
        let timerService = TimerServiceMock()
        let gameService = GameServiceMock()
        
        gameService.validateHandler = { input, secret in
            // Mark everything as correct
            input.enumerated().map { i, box in
                var boxCopy = box
                boxCopy.state = .correct
                boxCopy.text = secret[i]
                return boxCopy
            }
        }
        
        let vm = GameViewModel(router: router, timerService: timerService, gameService: gameService)
        vm.startGame()
        
        // populate input to pass checks
        for i in 0..<vm.playerInput.count {
            vm.playerInput[i].text = "Z"
        }
        
        vm.onCheckTapped()
        
        #expect(router.pushedRoutes.count == 1)
        if case let .result(success, _) = router.pushedRoutes.first! {
            #expect(success == true)
        } else {
            Issue.record("Unexpected result route")
        }
    }
    
    @Test("colorForInputBox maps states and handles out-of-bounds")
    func testColorForInputBox() async throws {
        let router = AppRouterMock()
        let timerService = TimerServiceMock()
        let gameService = GameServiceMock()
        let vm = GameViewModel(router: router, timerService: timerService, gameService: gameService)
        
        vm.playerInput = [
            InputBox(text: "", state: .empty),
            InputBox(text: "A", state: .correct),
            InputBox(text: "B", state: .misplaced),
            InputBox(text: "Z", state: .wrong),
        ]
        
        #expect(vm.colorForInputBox(at: -1) == .white)
        #expect(vm.colorForInputBox(at: 4) == .white)
        
        #expect(vm.colorForInputBox(at: 0) == .white)
        #expect(vm.colorForInputBox(at: 1) == .green)
        #expect(vm.colorForInputBox(at: 2) == .orange)
        #expect(vm.colorForInputBox(at: 3) == .red)
    }
}
