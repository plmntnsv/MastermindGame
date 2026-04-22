//
//  InputBox.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 22.04.26.
//

import Foundation

struct InputBox {
    var text: String = ""
    var state: InputBoxState = .empty
}

enum InputBoxState {
    case empty
    case correct
    case misplaced
    case wrong
}
