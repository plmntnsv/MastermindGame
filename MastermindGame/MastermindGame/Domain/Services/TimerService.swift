//
//  TimerService.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 22.04.26.
//

import Foundation

protocol TimerService {
    func start(duration: Int, onTick: @escaping (Int) -> Void, completion: @escaping () -> Void)
    func stop()
}

final class GameTimerService: TimerService {
    private var timer: Timer?
    private var remaining: Int = 0
    
    func start(
        duration: Int,
        onTick: @escaping (Int) -> Void,
        completion: @escaping () -> Void
    ) {
        stop()
        
        remaining = duration
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            onTick(self.remaining)
            
            if self.remaining <= 0 {
                self.stop()
                completion()
            }
            
            self.remaining -= 1
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
