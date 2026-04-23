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
                #expect(letter.count == 1)
                #expect(Character(letter).isUppercase)
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
        let secret = ["A", "B", "C", "D"]

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
        var input = [InputBox(text: "A", state: .empty)]
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
        input = [InputBox(text: "ABCDF", state: .empty)]
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
        var secret = ["A", "B", "C", "D"]

        // All correct
        var input = [
            InputBox(text: "A", state: .empty),
            InputBox(text: "B", state: .empty),
            InputBox(text: "C", state: .empty),
            InputBox(text: "D", state: .empty),
        ]
        if case .success(let result) = service.validate(input: input, against: secret) {
            #expect(result.allSatisfy({ $0.state == .correct }))
        } else {
            Issue.record("Expected success for all correct input")
        }

        // All wrong
        input = [
            InputBox(text: "Z", state: .empty),
            InputBox(text: "Y", state: .empty),
            InputBox(text: "X", state: .empty),
            InputBox(text: "W", state: .empty),
        ]
        if case .success(let result) = service.validate(input: input, against: secret) {
            #expect(result.allSatisfy({ $0.state == .wrong }))
        } else {
            Issue.record("Expected success for all wrong input")
        }

        // Misplaced cases
        input = [
            InputBox(text: "B", state: .empty),
            InputBox(text: "C", state: .empty),
            InputBox(text: "D", state: .empty),
            InputBox(text: "A", state: .empty),
        ]
        if case .success(let result) = service.validate(input: input, against: secret) {
            #expect(result.allSatisfy({ $0.state == .misplaced }))
        } else {
            Issue.record("Expected success for all misplaced input")
        }

        // Mixed correct and misplaced and wrong
        input = [
            InputBox(text: "A", state: .empty),
            InputBox(text: "X", state: .empty),
            InputBox(text: "B", state: .empty),
            InputBox(text: "D", state: .empty),
        ]
        if case .success(let result) = service.validate(input: input, against: secret) {
            #expect(result[0].state == .correct)
            #expect(result[1].state == .wrong)
            #expect(result[2].state == .misplaced)
            #expect(result[3].state == .correct)
        } else {
            Issue.record("Expected success for mixed input")
        }
        
        // Repeating secret, all correct
        secret = ["A", "A", "A", "A"]
        input = [
            InputBox(text: "A", state: .empty),
            InputBox(text: "A", state: .empty),
            InputBox(text: "A", state: .empty),
            InputBox(text: "A", state: .empty),
        ]
        if case .success(let result) = service.validate(input: input, against: secret) {
            #expect(result.allSatisfy({ $0.state == .correct }))
        } else {
            Issue.record("Expected success for all correct input")
        }
        
        // 2 correct, 2 misplaced
        secret = ["A", "A", "A", "B"]
        input = [
            InputBox(text: "B", state: .empty),
            InputBox(text: "A", state: .empty),
            InputBox(text: "A", state: .empty),
            InputBox(text: "A", state: .empty),
        ]
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
        let secret = ["A", "B", "C", "D"]

        // Non A–Z symbols
        var input = [
            InputBox(text: "a", state: .empty),
            InputBox(text: "ъ", state: .empty),
            InputBox(text: "Hello", state: .empty),
            InputBox(text: "大", state: .empty),
        ]
        switch service.validate(input: input, against: secret) {
            case .success(let result):
                Issue.record("Expected failure for invalid characters, got success with: \(result)")
            case .failure(let error):
                if case .invalidCharacterCount = error {
                    // ok
                } else {
                    Issue.record("Unexpected error: \(error)")
                }
        }
        
        // Numbers
        input = [
            InputBox(text: "1", state: .empty),
            InputBox(text: "2", state: .empty),
            InputBox(text: "3", state: .empty),
            InputBox(text: "4", state: .empty),
        ]
        
        switch service.validate(input: input, against: secret) {
        case .success(let result):
            #expect(result.allSatisfy({ $0.state == .wrong }))
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }
}

