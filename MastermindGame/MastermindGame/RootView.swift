//
//  ContentView.swift
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
                    router.view(for: route)
                }
        }
        .environment(router)
    }
}

#Preview {
    RootView(router: AppRouter())
}
