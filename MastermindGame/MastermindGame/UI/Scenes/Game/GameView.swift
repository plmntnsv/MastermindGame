//
//  GameView.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import SwiftUI

struct GameView: View {
    @Environment(AppRouter.self) private var router
    var body: some View {
        VStack {
            Text("GAME")
            Button {
                router.push(.result(success: true))
            } label: {
                Text("TO RESULT")
            }

        }
    }
}

#Preview {
    GameView()
}
