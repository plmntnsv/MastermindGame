//
//  ResultView.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import SwiftUI

struct ResultView: View {
    @State var viewModel: ResultViewModelType
    @State private var isVisible = false
    @State private var isScaled = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: viewModel.isSuccess ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                .font(.system(size: 60))
                .foregroundStyle(viewModel.isSuccess ? .green : .orange)
            
            Text(viewModel.isSuccess ? "Good job!" : "Game over!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.black)
            
            Text(viewModel.isSuccess ?
                    "You've guessed it!" :
                    "You've failed to guess:\n\(Text(viewModel.secret.joined(separator: " ")).bold())")
                .font(.title)
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
            
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
