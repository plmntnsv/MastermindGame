//
//  GameFactory.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 21.04.26.
//

import Foundation
import SwiftUI

final class GameFactory {
    static func makeGameView() -> GameView {
        GameView()
    }
    
    static func makeResultView(isSuccess: Bool) -> ResultView {
        ResultView()
    }
}
