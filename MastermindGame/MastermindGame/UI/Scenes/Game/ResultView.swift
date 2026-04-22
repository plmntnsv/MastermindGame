//
//  ResultView.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import SwiftUI

struct ResultView: View {
    @State var viewModel: ResultViewModel
    @State private var isVisible = false
    @State private var isScaled = false
    
    private var imageName: String {
        viewModel.isSuccess ? "hand.thumbsup.fill" : "hand.thumbsdown.fill"
    }
    
    private var title: String {
        viewModel.isSuccess ? "Good job!" : "Game over!"
    }
    
    private var subtitle: String {
        viewModel.isSuccess ?
            "You've guessed it!" :
            "You've failed to guess:\n\(Text(viewModel.secret.joined(separator: " ")).bold())"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .font(.system(size: 60))
                .foregroundStyle(.green)
                .phaseAnimator([1, 2, 3]) { view, phase in
                    view
                        .scaleEffect(phase == 1 ? 1 : 1.2)
                }
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(subtitle)
                .font(.title)
                .multilineTextAlignment(.center)
            Button("Retry") {
                viewModel.onRetryTapped()
            }
            .buttonStyle(AppButtonStyle(backgroundColor: viewModel.isSuccess ? .green : .orange))
            .padding()
        }
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackgroundMain)
    }
}

#Preview {
    ResultView(viewModel: ResultViewModel(router: AppRouter(), isSuccess: true, secret: ["A", "B", "C", "D"]))
}
