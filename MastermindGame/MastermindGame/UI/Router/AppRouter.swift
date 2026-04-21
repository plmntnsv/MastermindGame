//
//  AppRouter.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import SwiftUI

enum AppRoute: Hashable {
    case game
    case result(success: Bool)
}

@Observable
final class AppRouter {
    var path = NavigationPath()
    static let shared = AppRouter()
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func view(for route: AppRoute) -> some View {
        switch route {
        case .game:
            GameFactory.makeGameView()
        case .result(let success):
            GameFactory.makeResultView(isSuccess: success)
        }
    }
}
