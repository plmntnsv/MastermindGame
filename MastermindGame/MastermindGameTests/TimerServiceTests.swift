//
//  TimerServiceTests.swift
//  MastermindGameTests
//
//  Created by Plamen Atanasov on 20.04.26.
//

import Testing
@testable import MastermindGame

@Suite("TimerServiceTests")
@MainActor
struct TimerServiceTests {
    @Test("ticks down to zero and calls completion")
    func testTimerTicksAndCompletes() async throws {
        let service = GameTimerService()
        var ticks: [Int] = []
        var completed = false
        
        let finished = AsyncStream<Void>.makeStream()
        let continuation = finished.continuation
        
        service.start(duration: 2, onTick: { remaining in
            ticks.append(remaining)
        }, completion: {
            completed = true
            continuation.yield()
            continuation.finish()
        })
        
        for await _ in finished.stream { }
        
        #expect(completed == true)
        #expect(ticks == [2, 1, 0])
    }

}
