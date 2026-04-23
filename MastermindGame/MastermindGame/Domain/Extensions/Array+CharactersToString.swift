//
//  Array+CharactersToString.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 23.04.26.
//

import Foundation

extension Array where Element == Character {
    func convertToString(separator: String = ", ") -> String {
        self.map { String($0) }.joined(separator: separator)
    }
}
