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
            
            HStack(spacing: 10) {
                ForEach(0..<viewModel.textCount, id: \.self) { index in
                    TextField("", text: $viewModel.playerInput[index].text)
                        .multilineTextAlignment(.center)
                        .frame(width: 50, height: 50)
                        .focused($focusedIndex, equals: index)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                                .fill(viewModel.colorForInputSlot(at: index))
                        )
                        .onChange(of: viewModel.playerInput[index].text) { _, newText in
                            if newText.count > 1 {
                                viewModel.playerInput[index].text = String(newText.prefix(1))
                            } else if newText.count == 1 {
                                if index < viewModel.textCount {
                                    focusedIndex = index + 1
                                }
                            }
                        }
                }
                
                Button("Check") {
                    viewModel.onCheckTapped()
                }
                .buttonStyle(AppButtonStyle())
            }
            
            Spacer()
            
            Text("\(viewModel.targetText.joined(separator: ", "))")
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackgroundMain)
        .onAppear {
            viewModel.generateTargetText()
            focusedIndex = 0
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel(router: AppRouter()))
}
