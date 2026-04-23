//
//  GameView.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import SwiftUI

struct GameView: View {
    @State var viewModel: GameViewModelType
    @FocusState private var focusedIndex: Int?
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            
            Group {
                if isLandscape {
                    VStack {
                        headerView
                        HStack(spacing: 25) {
                            timerView
                            boxesView
                            buttonView
                        }
                        Spacer()
                        debugHintView
                    }
                } else {
                    VStack(spacing: 25) {
                        headerView
                        timerView
                        boxesView
                        buttonView
                        Spacer()
                        debugHintView
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 30)
            .background(Color.appBackgroundMain)
            .onChange(of: viewModel.isGameRunning) { _, isRunning in
                if !isRunning {
                    focusedIndex = 0
                }
            }
            .onAppear {
                viewModel.startGame()
                focusedIndex = 0
            }
            .applyErrorHandling(error: $viewModel.error)
        }
    }
    
    var headerView: some View {
        Text("Mastermind Game")
            .font(.largeTitle)
            .bold()
            .foregroundStyle(.black)
    }
    
    var timerView: some View {
        TimerView(
            totalTime: viewModel.totalTime,
            remaining: $viewModel.remainingTime
        )
    }
    
    var boxesView: some View {
        HStack(spacing: 10) {
            ForEach(0..<viewModel.secretLength, id: \.self) { index in
                TextField("", text: $viewModel.playerInput[index].text)
                    .multilineTextAlignment(.center)
                    .textCase(.uppercase)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .foregroundStyle(.black)
                    .keyboardType(.asciiCapable)
                    .focused($focusedIndex, equals: index)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 5)
                            .fill(viewModel.colorForInputBox(at: index))
                    )
                    .onChange(of: viewModel.playerInput[index].text) { _, newText in
                        let text = newText.uppercased()
                        
                        if text.count > 1 {
                            viewModel.playerInput[index].text = String(text.prefix(1))
                        } else {
                            viewModel.playerInput[index].text = text
                        }
                        
                        if viewModel.playerInput[index].text.count == 1 &&
                           index < viewModel.secretLength - 1 {
                            focusedIndex = index + 1
                        }
                    }
            }
        }
    }
    
    var buttonView: some View {
        Button("Check") {
            viewModel.onCheckTapped()
        }
        .buttonStyle(AppButtonStyle())
    }
    
    var debugHintView: some View {
        Text("\(viewModel.debugSecretLetters.joined(separator: ", "))")
            .padding()
            .foregroundStyle(.white)
    }
}

#Preview {
    GameView(viewModel: GameViewModel(
        router: AppRouter(),
        timerService: GameTimerService(),
        gameService: GameService())
    )
}
