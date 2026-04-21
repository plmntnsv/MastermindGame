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
            Text(viewModel.isSuccess ? "SUCCESS" : "FAILURE")
                .font(.largeTitle)
                .bold()
            Button("Retry") {
                viewModel.onRetryTapped()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ResultView(viewModel: ResultViewModel(router: AppRouter(), isSuccess: true))
}
