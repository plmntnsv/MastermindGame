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
    let secret: [String]
    
    init(router: AppRouter, isSuccess: Bool, secret: [String]) {
        self.router = router
        self.isSuccess = isSuccess
        self.secret = secret
    }
    
    func onRetryTapped() {
        router.popToRoot()
    }
}
