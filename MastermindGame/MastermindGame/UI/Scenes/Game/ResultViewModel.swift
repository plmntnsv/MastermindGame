//
//  ResultViewModel.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import Foundation

protocol ResultViewModelType: AnyObject {
    var isSuccess: Bool { get }
    var secret: [Character] { get }
    var secretString: String { get }
    func onRetryTapped()
}

@Observable
final class ResultViewModel: ResultViewModelType {
    let router: AppRouting
    let isSuccess: Bool
    let secret: [Character]
    
    var secretString: String {
        secret.convertToString(separator: " ")
    }
    
    init(router: AppRouting, isSuccess: Bool, secret: [Character]) {
        self.router = router
        self.isSuccess = isSuccess
        self.secret = secret
    }
    
    func onRetryTapped() {
        router.popToRoot()
    }
}
