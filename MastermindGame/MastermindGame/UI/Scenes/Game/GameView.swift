//
//  GameView.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import SwiftUI

struct GameView: View {
    @State var viewModel: GameViewModel
    @FocusState private var focusedIndex: Int?
    
    var body: some View {
        VStack {
            Text("\(viewModel.targetText)")
            Text("Mastermind Game")
                .font(.largeTitle)
                .bold()
            
            HStack(spacing: 10) {
                ForEach(0..<viewModel.textCount, id: \.self) { index in
                    TextField("", text: $viewModel.playerInput[index].text)
                        .multilineTextAlignment(.center)
                        .frame(width: 50, height: 50)
                        .background(viewModel.playerInput[index].state.color)
                        .focused($focusedIndex, equals: index)
                        .onChange(of: viewModel.playerInput[index].text) { _, new in
                            handleInput(new, index: index)
                        }
                }
                
                Button("Check") {
                    viewModel.onCheckTapped()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.generateTargetText()
            focusedIndex = 0
        }
    }
    
    func handleInput(_ text: String, index: Int) {
        if text.count > 1 {
            viewModel.playerInput[index].text = String(text.prefix(1))
        } else if text.count == 1 {
            if index < viewModel.textCount {
                focusedIndex = index + 1
            }
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel(router: AppRouter()))
}
