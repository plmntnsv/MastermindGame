//
//  RootView.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import SwiftUI

struct RootView: View {
    @State var router: AppRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            GameView()
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
        .environment(router)
    }
}

extension RootView {
    @ViewBuilder
    func destination(for route: AppRoute) -> some View {
        switch route {
        case .game:
            GameFactory.makeGameView()
        case .result(let success):
            GameFactory.makeResultView(isSuccess: success)
        }
    }
}

#Preview {
    RootView(router: AppRouter())
}
