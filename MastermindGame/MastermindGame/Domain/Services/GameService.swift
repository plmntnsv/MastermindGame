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
    private static let characters = (65...70).map { Character(UnicodeScalar($0)) } // A to Z
    
    func generateSecret(length: Int) -> Result<[Character], GameError> {
        guard length > 0 else {
            return .failure(.invalidSecretLength(actual: length))
        }
        
        let secret: [Character] = (0..<length).map { _ in Self.characters.randomElement()! }
        
        return .success(secret)
    }
    
    func validate(input: [Character], against secret: [Character]) -> Result<[InputBox], GameError> {
        guard !input.isEmpty, input.count == secret.count else {
            return .failure(.invalidInput)
        }
        
        var result = input.map { InputBox(letter:$0, state: .empty) }
        var secretSet = Set<Character>()
        
        // first pass to mark all the .correct letters
        // and mark the rest as .wrong
        for i in 0..<input.count {
            if input[i] == secret[i] {
                result[i].state = .correct
            } else {
                result[i].state = .wrong
                secretSet.insert(secret[i])
            }
        }
        
        // second pass to match the misplaced letters
        for i in result.indices where result[i].state == .wrong {
            if secretSet.contains(result[i].letter) {
                result[i].state = .misplaced
            }
        }
        
        return .success(result)
    }
}
