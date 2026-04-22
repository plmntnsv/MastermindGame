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
            Text("Mastermind Game")
                .font(.largeTitle)
                .bold()
                .padding([.top, .bottom], 20)
            
            Text("\(viewModel.remainingTime)")
                .font(.system(size: 30))
                .bold()
            
            HStack(spacing: 10) {
                ForEach(0..<viewModel.secretCount, id: \.self) { index in
                    TextField("", text: $viewModel.playerInput[index].text)
                        .multilineTextAlignment(.center)
                        .textCase(.uppercase)
                        .focused($focusedIndex, equals: index)
                        .frame(width: 50, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                                .fill(viewModel.colorForInputSlot(at: index))
                        )
                        .onChange(of: viewModel.playerInput[index].text) { _, newText in
                            if newText.count > 1 {
                                viewModel.playerInput[index].text = String(newText.prefix(1))
                            } else if newText.count == 1 && index < viewModel.secretCount {
                                focusedIndex = index + 1
                            }
                        }
                }
                
                Button("Check") {
                    viewModel.onCheckTapped()
                }
                .buttonStyle(AppButtonStyle())
            }
            
            Spacer()
            
            Text("\(viewModel.secretLetters.joined(separator: ", "))")
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackgroundMain)
        .onChange(of: viewModel.isGameRunning) { _, isRunning in
            if !isRunning {
                focusedIndex = 0
            }
        }
        .onAppear {
            viewModel.startGame()
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel(router: AppRouter(), timerService: GameTimerService()))
}
