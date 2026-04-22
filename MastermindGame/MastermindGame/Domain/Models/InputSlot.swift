//
//  InputSlot.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 22.04.26.
//

import Foundation

struct InputSlot {
    var text: String = ""
    var state: InputSlotState = .empty
}

enum InputSlotState {
    case empty
    case correct
    case misplaced
    case wrong
}
