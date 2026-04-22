//
//  GameEngine.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 22.04.26.
//

import Foundation

protocol GameServiceProtocol {
    var secretCount: Int { get }
    func generateSecret() -> [String]
    func validate(input: [InputSlot], against secret: [String]) -> [InputSlot]
}

class GameService: GameServiceProtocol {
    let secretCount = 4
    private let characters: [String] = (65...90).map { String(UnicodeScalar($0)) } // A to Z
    
    func generateSecret() -> [String] {
        (0..<secretCount).map { _ in characters.randomElement()! }
    }
    
    func validate(input: [InputSlot], against secret: [String]) -> [InputSlot] {
        var secretCopy = secret
        var inputCopy = input
        
        for index in 0..<secretCount {
            let letter = input[index].text
            
            if letter == secretCopy[index] {
                inputCopy[index].state = .correct
                secretCopy[index] = ""
            } else {
                inputCopy[index].state = .wrong
            }
        }
        
        for index in 0..<secretCount {
            if inputCopy[index].state == .correct {
                continue
            }
            
            let letter = input[index].text
            
            if secretCopy.contains(letter) && !letter.isEmpty {
                inputCopy[index].state = .misplaced
            }
        }
        
        return inputCopy
    }
}
