//
//  GameServiceErrors.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 22.04.26.
//

import Foundation

enum AppError: Error, Identifiable {
    case invalidLength(expected: String, actual: String)
    case inputMissmatch
    case invalidCharacterCount(char: String, at: Int)
    
    var id: String { errorMessage }
    
    var errorMessage: String {
        switch self {
        case .invalidLength(expected: let expected, actual: let actual):
            return "Expected to see \(expected), but got \(actual)"
        case .inputMissmatch:
            return "Invalid input or secret provided"
        case .invalidCharacterCount(char: let char, at: let index):
            return "Invalid '\(char)' at index \(index)"
        }
    }
}

