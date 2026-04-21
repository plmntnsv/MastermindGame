//
//  MastermindGameApp.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import SwiftUI

@main
struct MastermindGameApp: App {
    private let router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            RootView(router: router)
        }
    }
}
