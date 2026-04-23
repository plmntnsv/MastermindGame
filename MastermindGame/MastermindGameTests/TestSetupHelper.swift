//
//  TestSetupHelper.swift
//  MastermindGameTests
//
//  Created by Plamen Atanasov on 23.04.26.
//

import SwiftUI
@testable import MastermindGame

enum TestConstant {
    static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
}

final class AppRouterMock: AppRouting {
    var path = NavigationPath()
    
    private(set) var pushedRoutes: [AppRoute] = []
    private(set) var popToRootCount = 0

    func push(_ route: AppRoute) {
        pushedRoutes.append(route)
    }

    func popToRoot() {
        popToRootCount += 1
        pushedRoutes.removeAll()
    }
    
    func pop() {
        pushedRoutes.removeLast()
    }
}

final class TimerServiceMock: TimerService {
    private(set) var startDuration: Int?
    private var onTick: ((Int) -> Void)?
    private var completion: (() -> Void)?
    
    func start(duration: Int, onTick: @escaping (Int) -> Void, completion: @escaping () -> Void) {
        startDuration = duration
        self.onTick = onTick
        self.completion = completion
    }
    
    func stop() {
        onTick = nil
        completion = nil
    }
    
    func sendTick(_ remaining: Int) {
        onTick?(remaining)
    }
    
    func finish() {
        completion?()
    }
}

final class GameServiceMock: GameServiceProtocol {
    var secretMock: [String] = ["A", "B", "C", "D"]
    var validateHandler: (([InputBox], [String]) -> [InputBox])?

    func generateSecret(length: Int) -> Result<[String], GameError> {
        .success(Array(secretMock.prefix(length)))
    }

    func validate(input: [InputBox], against secret: [String]) -> Result<[InputBox], GameError> {
        if let handler = validateHandler {
            return .success(handler(input, secret))
        }
        return .success(input)
    }
}
