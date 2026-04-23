//
//  ErrorHandlingModifier.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 23.04.26.
//

import SwiftUI

struct ErrorHandlingModifier: ViewModifier {
    @Binding var error: GameError?

    func body(content: Content) -> some View {
        content
            .alert(item: $error) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.errorMessage),
                    dismissButton: .default(Text("OK")) {
                        self.error = nil
                    }
                )
            }
    }
}

extension View {
    func applyErrorHandling(error: Binding<GameError?>) -> some View {
        self.modifier(ErrorHandlingModifier(error: error))
    }
}
