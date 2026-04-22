//
//  AppRouter.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import SwiftUI

enum AppRoute: Hashable {
    case game
    case result(success: Bool, secret: [String])
}

@Observable
final class AppRouter {
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
