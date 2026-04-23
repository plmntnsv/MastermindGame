//
//  GameError.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 22.04.26.
//

import Foundation

enum GameError: Error, Identifiable {
    case invalidSecretLength(actual: Int)
    case invalidInput
    case invalidInputLength
    case unexpectedError
    
    var id: String { errorMessage }
    
    var errorMessage: String {
        switch self {
        case .invalidSecretLength(let actual):
            return "Secret length should be at least 1 but was: \(actual)"
        case .invalidInput:
            return "Invalid input provided"
        case .invalidInputLength:
            return "Invalid input. Should be 1 character."
        case .unexpectedError:
            return "Unexpected error occurred"
        }
    }
}

