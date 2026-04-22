//
//  ResultView.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 20.04.26.
//

import SwiftUI

struct ResultView: View {
    @State var viewModel: ResultViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.isSuccess ? "You've guessed it! Good job!" : "You've failed!")
                .font(.largeTitle)
                .bold()
            Button("Retry") {
                viewModel.onRetryTapped()
            }
            .buttonStyle(AppButtonStyle(backgroundColor: .orange))
            .padding()
        }
        .navigationBarBackButtonHidden()
        .background(Color.appBackgroundMain)
    }
}

#Preview {
    ResultView(viewModel: ResultViewModel(router: AppRouter(), isSuccess: true))
}
