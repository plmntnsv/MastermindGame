//
//  ResultViewModelTests.swift
//  MastermindGameTests
//
//  Created by Plamen Atanasov on 20.04.26.
//

import Testing
@testable import MastermindGame

@Suite("ResultViewModel")
@MainActor
struct ResultViewModelTests {
    @Test("onRetryTapped pops to root")
    func testOnRetryTapped() async throws {
        let router = AppRouterMock()
        let vm = ResultViewModel(router: router, isSuccess: true, secret: ["A", "B", "C", "D"])
        
        #expect(router.popToRootCount == 0)
        vm.onRetryTapped()
        #expect(router.popToRootCount == 1)
    }
}
