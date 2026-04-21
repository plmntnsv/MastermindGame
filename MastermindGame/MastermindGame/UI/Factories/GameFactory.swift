//
//  GameFactory.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 21.04.26.
//

import Foundation

struct GameFactory {
    static func makeGameView(router: AppRouter) -> GameView {
        let vm = GameViewModel(router: router)
        return GameView(viewModel: vm)
    }
    
    static func makeResultView(router: AppRouter, isSuccess: Bool) -> ResultView {
        let vm = ResultViewModel(router: router, isSuccess: isSuccess)
        return ResultView(viewModel: vm)
    }
    
    static func makeRootView() {
        
    }
}
