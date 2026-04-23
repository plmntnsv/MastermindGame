//
//  GameServiceTests.swift
//  MastermindGameTests
//
//  Created by Plamen Atanasov on 20.04.26.
//

import Foundation
import Testing
@testable import MastermindGame

@Suite("GameService")
@MainActor
struct GameServiceTests {
    @Test("generateSecret - returns requested length with A-Z letters")
    func testGenerateSecret() async throws {
        let service = GameService()
        let result = service.generateSecret(length: 4)
        
        switch result {
        case .success(let secret):
            #expect(secret.count == 4)
            
            for letter in secret {
                #expect(letter.isUppercase)
                #expect(TestConstant.letters.contains(letter))
            }
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("generateSecret - returns larger arrays")
    func testGenerateSecretLarge() async throws {
        let service = GameService()
        let result = service.generateSecret(length: 100)

        switch result {
        case .success(let secret):
            #expect(secret.count == 100)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("generateSecret - returns failure for non-positive length")
    func testGenerateSecretEmpty() async throws {
        let service = GameService()

        switch service.generateSecret(length: 0) {
        case .success(let secret):
            Issue.record("Unexpected success with: \(secret)")
        case .failure(let error):
            if case .invalidSecretLength = error {
                // ok
            } else {
                Issue.record("Unexpected error: \(error)")
            }
        }

        switch service.generateSecret(length: -1) {
        case .success(let secret):
            Issue.record("Expected failure for length -1, but got success with: \(secret)")
        case .failure(let error):
            if case .invalidSecretLength = error {
                // ok
            } else {
                Issue.record("Unexpected error: \(error)")
            }
        }
    }

    @Test("validate - returns failure for invalid inputs")
    func testValidateInvalidInputs() async throws {
        let service = GameService()
        let secret: [Character] = ["A", "B", "C", "D"]

        // empty
        switch service.validate(input: [], against: secret) {
        case .success(let validated):
            Issue.record("Expected failure for empty input, got success with: \(validated)")
        case .failure(let error):
            if case .invalidInput = error {
                // ok
            } else {
                Issue.record("Unexpected error: \(error)")
            }
        }

        // wrong length - less
        var input: [Character] = ["A"]
        switch service.validate(input: input, against: secret) {
        case .success(let validated):
            Issue.record("Expected failure for smaller length, got success with: \(validated)")
        case .failure(let error):
            if case .invalidInput = error {
                // ok
            } else {
                Issue.record("Unexpected error: \(error)")
            }
        }
        
        // wrong length - more
        input = ["A", "B", "C", "D", "F"]
        switch service.validate(input: input, against: secret) {
        case .success(let validated):
            Issue.record("Expected failure for bigger length, got success with: \(validated)")
        case .failure(let error):
            if case .invalidInput = error {
                // ok
            } else {
                Issue.record("Unexpected error: \(error)")
            }
        }
    }

    @Test("validate - marks correct, misplaced, and wrong correctly")
    func testValidateInput() async throws {
        let service = GameService()
        var secret: [Character] = ["A", "B", "C", "D"]

        // All correct
        var input: [Character] = ["A", "B", "C", "D"]
        if case .success(let result) = service.validate(input: input, against: secret) {
            #expect(result.allSatisfy({ $0.state == .correct }))
        } else {
            Issue.record("Expected success for all correct input")
        }

        // All wrong
        input = ["Z", "Y", "X", "W"]
        if case .success(let result) = service.validate(input: input, against: secret) {
            #expect(result.allSatisfy({ $0.state == .wrong }))
        } else {
            Issue.record("Expected success for all wrong input")
        }

        // Misplaced cases
        input = ["B", "C", "D", "A"]
        if case .success(let result) = service.validate(input: input, against: secret) {
            #expect(result.allSatisfy({ $0.state == .misplaced }))
        } else {
            Issue.record("Expected success for all misplaced input")
        }

        // Mixed correct and misplaced and wrong
        input = ["A", "X", "B", "D"]
        if case .success(let result) = service.validate(input: input, against: secret) {
            #expect(result[0].state == .correct)
            #expect(result[1].state == .wrong)
            #expect(result[2].state == .misplaced)
            #expect(result[3].state == .correct)
        } else {
            Issue.record("Expected success for mixed input")
        }
        
        secret = ["O", "Q", "C", "D"]
        input = ["O", "Z", "Q", "Q"]
        if case .success(let result) = service.validate(input: input, against: secret) {
            #expect(result[0].state == .correct)
            #expect(result[1].state == .wrong)
            #expect(result[2].state == .misplaced)
            #expect(result[3].state == .wrong)
        } else {
            Issue.record("Expected success for mixed input")
        }
        
        // Repeating secret, all correct
        secret = ["A", "A", "A", "A"]
        input = ["A", "A", "A", "A"]
        if case .success(let result) = service.validate(input: input, against: secret) {
            #expect(result.allSatisfy({ $0.state == .correct }))
        } else {
            Issue.record("Expected success for all correct input")
        }
        
        // 2 correct, 2 misplaced
        secret = ["A", "A", "A", "B"]
        input = ["B", "A", "A", "A"]
        if case .success(let result) = service.validate(input: input, against: secret) {
            #expect(result[0].state == .misplaced)
            #expect(result[1].state == .correct)
            #expect(result[2].state == .correct)
            #expect(result[3].state == .misplaced)
        } else {
            Issue.record("Expected success for all correct input")
        }
    }

    @Test("validate - unexpected symbols")
    func testValidateUnexpectedInput() async throws {
        let service = GameService()
        let secret: [Character] = ["A", "B", "C", "D"]

        // Non A–Z symbols
        var input: [Character] = ["a", "ъ", "大", "👀"]
        switch service.validate(input: input, against: secret) {
            case .success(let result):
                #expect(result.allSatisfy({ $0.state == .wrong }))
            case .failure(let error):
                Issue.record("Unexpected error: \(error)")
        }
        
        // Numbers
        input = ["1", "2", "3", "4"]
        switch service.validate(input: input, against: secret) {
        case .success(let result):
            #expect(result.allSatisfy({ $0.state == .wrong }))
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
}

