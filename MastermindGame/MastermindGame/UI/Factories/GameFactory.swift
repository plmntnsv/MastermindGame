//
//  GameFactory.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 21.04.26.
//

import Foundation

struct GameFactory {
    static func makeGameView(
        router: AppRouter,
        timeService: TimerService = GameTimerService(),
        gameService: GameServiceProtocol = GameService()) -> GameView {
        let vm = GameViewModel(router: router, timerService: timeService, gameService: gameService)
        return GameView(viewModel: vm)
    }
    
    static func makeResultView(router: AppRouter, isSuccess: Bool, secret: [String]) -> ResultView {
        let vm = ResultViewModel(router: router, isSuccess: isSuccess, secret: secret)
        return ResultView(viewModel: vm)
    }
    
    static func makeRootView() {
        
    }
}
