//
//  GameEngine.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 22.04.26.
//

import Foundation

protocol GameServiceProtocol {
    func generateSecret(length: Int) -> [String]
    func validate(input: [InputBox], against secret: [String]) -> [InputBox]
}

final class GameService: GameServiceProtocol {
    private let characters: [String] = (65...90).map { String(UnicodeScalar($0)) } // A to Z
    
    func generateSecret(length: Int) -> [String] {
        guard length > 0 else {
            return []
        }
        
        return (0..<length).map { _ in characters.randomElement()! }
    }
    
    func validate(input: [InputBox], against secret: [String]) -> [InputBox] {
        guard !input.isEmpty, input.count == secret.count else {
            return []
        }
        
        let count = input.count
        var secretCopy = secret
        var inputCopy = input
        
        // first pass to get all the correct values
        // and marks the rest as wrong
        for index in 0..<count {
            let letter = input[index].text
            
            if letter == secretCopy[index] {
                inputCopy[index].state = .correct
                secretCopy[index] = ""
            } else {
                inputCopy[index].state = .wrong
            }
        }
        
        // second pass to match the misplaced values
        for index in 0..<count {
            if inputCopy[index].state == .correct {
                continue
            }
            
            let letter = input[index].text
            
            if secretCopy.contains(letter) && !letter.isEmpty {
                inputCopy[index].state = .misplaced
                secretCopy[index] = ""
            }
        }
        
        return inputCopy
    }
}
