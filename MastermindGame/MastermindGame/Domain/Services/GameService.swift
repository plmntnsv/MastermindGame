//
//  GameEngine.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 22.04.26.
//

import Foundation

protocol GameServiceProtocol {
    func generateSecret(length: Int) -> Result<[String], GameError>
    func validate(input: [InputBox], against secret: [String]) -> Result<[InputBox], GameError>
}

final class GameService: GameServiceProtocol {
    private static let characters: [String] = (65...90).map { String(UnicodeScalar($0)) } // A to Z
    
    func generateSecret(length: Int) -> Result<[String], GameError> {
        guard length > 0 else {
            return .failure(.invalidSecretLength(actual: length))
        }
        
        var secret: [String] = []
        for _ in 0..<length {
            guard let random = Self.characters.randomElement() else {
                return .failure(.unexpectedError)
            }
            
            secret.append(random)
        }
        
        return .success(secret)
    }
    
    func validate(input: [InputBox], against secret: [String]) -> Result<[InputBox], GameError> {
        guard !input.isEmpty, input.count == secret.count else {
            return .failure(.invalidInput)
        }
        
        let count = input.count
        var result = input
        var frequency: [String: Int] = [:]
        
        // first pass to get all the correct values
        // and to mark the rest as wrong
        for i in 0..<count {
            let letter = result[i].text
            
            guard letter.count == 1 else {
                return .failure(.invalidCharacterCount(char: letter, at: i))
            }
            
            if letter == secret[i] {
                result[i].state = .correct
            } else {
                result[i].state = .wrong
                frequency[secret[i], default: 0] += 1
            }
        }
        
        // second pass to match the misplaced values
        for i in result.indices where result[i].state == .wrong {
            let letter = result[i].text
            
            if let count = frequency[letter], count > 0 {
                result[i].state = .misplaced
                frequency[letter] = count - 1
            }
        }
        
        return .success(result)
    }
}
