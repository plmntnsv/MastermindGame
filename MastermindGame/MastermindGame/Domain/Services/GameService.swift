//
//  GameEngine.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 22.04.26.
//

import Foundation

protocol GameServiceProtocol {
    func generateSecret(length: Int) -> Result<[Character], GameError>
    func validate(input: [Character], against secret: [Character]) -> Result<[InputBox], GameError>
}

final class GameService: GameServiceProtocol {
    private static let characters = (65...90).map { Character(UnicodeScalar($0)) } // A to Z
    
    func generateSecret(length: Int) -> Result<[Character], GameError> {
        guard length > 0 else {
            return .failure(.invalidSecretLength(actual: length))
        }
        
        var secret = [Character]()
        for _ in 0..<length {
            guard let random = Self.characters.randomElement() else {
                return .failure(.unexpectedError)
            }
            
            secret.append(random)
        }
        
        return .success(secret)
    }
    
    func validate(input: [Character], against secret: [Character]) -> Result<[InputBox], GameError> {
        guard !input.isEmpty, input.count == secret.count else {
            return .failure(.invalidInput)
        }
        
        var result = input.map { InputBox(letter:$0, state: .empty) }
        var frequency: [Character: Int] = [:]
        
        // first pass to get all the correct values
        // and to mark the rest as wrong
        // and icrease secret letters frequencies
        for i in 0..<input.count {
            if input[i] == secret[i] {
                result[i].state = .correct
            } else {
                result[i].state = .wrong
                frequency[secret[i], default: 0] += 1
            }
        }
        
        // second pass to match the misplaced values
        for i in result.indices where result[i].state == .wrong {
            let letter = result[i].letter
            
            if let count = frequency[letter], count > 0 {
                result[i].state = .misplaced
                frequency[letter] = count - 1
            }
        }
        
        return .success(result)
    }
}
