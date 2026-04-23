//
//  GameEngine.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 22.04.26.
//

import Foundation

protocol GameServiceProtocol {
    func generateSecret(length: Int) -> Result<[String], AppError>
    func validate(input: [InputBox], against secret: [String]) -> Result<[InputBox], AppError>
}

final class GameService: GameServiceProtocol {
    private let characters: [String] = (65...90).map { String(UnicodeScalar($0)) } // A to Z
    
    func generateSecret(length: Int) -> Result<[String], AppError> {
        guard length > 0 else {
            return .failure(.invalidLength(expected: "At least 1", actual: "\(length)"))
        }
        
        let secret = (0..<length).compactMap { _ in characters.randomElement() }
        return .success(secret)
    }
    
    func validate(input: [InputBox], against secret: [String]) -> Result<[InputBox], AppError> {
        guard !input.isEmpty, input.count == secret.count else {
            return .failure(.inputMissmatch)
        }
        
        let count = input.count
        var secretCopy = secret
        var inputCopy = input
        
        // first pass to get all the correct values
        // and to mark the rest as wrong
        for index in 0..<count {
            let letter = input[index].text
            
            guard letter.count == 1 else {
                return .failure(.invalidCharacterCount(char: letter, at: index))
            }
            
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
            
            if !letter.isEmpty, let foundIndex = secretCopy.firstIndex(of: letter) {
                inputCopy[index].state = .misplaced
                secretCopy[foundIndex] = ""
            }
        }
        
        return .success(inputCopy)
    }
}
