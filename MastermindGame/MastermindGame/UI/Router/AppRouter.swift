//
//  AppRouter.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import SwiftUI

protocol AppRouting {
    var path: NavigationPath { get set }
    func push(_ route: AppRoute)
    func pop()
    func popToRoot()
}

enum AppRoute: Hashable {
    case game
    case result(success: Bool, secret: [String])
}

@Observable
final class AppRouter: AppRouting {
    var path = NavigationPath()
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
