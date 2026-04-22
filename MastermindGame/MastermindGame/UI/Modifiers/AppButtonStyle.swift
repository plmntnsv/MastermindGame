//
//  CapsuleButtonModifier.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 22.04.26.
//

import SwiftUI

struct AppButtonStyle: ButtonStyle {
    var foregroundColor: Color = .white
    var backgroundColor: Color = .green
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .padding(10)
            .background(configuration.isPressed ? backgroundColor.opacity(0.6) : backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
