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
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    @ViewBuilder
    func view(for route: AppRoute) -> some View {
        switch route {
        case .game:
            GameScreen()
        case .result(let success):
            ResultSCreen()
        }
    }
}
