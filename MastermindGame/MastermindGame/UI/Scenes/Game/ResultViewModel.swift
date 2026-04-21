//
//  ResultViewModel.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import Foundation

@Observable
final class ResultViewModel {
    var router: AppRouter
    let isSuccess: Bool
    
    init(router: AppRouter, isSuccess: Bool) {
        self.router = router
        self.isSuccess = isSuccess
    }
    
    func onRetryTapped() {
        router.popToRoot()
    }
}
