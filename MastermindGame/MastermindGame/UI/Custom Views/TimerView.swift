//
//  TimerView.swift
//  MastermindGame
//
//  Created by Plamen Atanasov on 22.04.26.
//

import SwiftUI

struct TimerView: View {
    let totalTime: Int
    @Binding var remaining: Int

    var progress: CGFloat {
        CGFloat(remaining) / CGFloat(totalTime)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.1), lineWidth: 8)
            
            Circle()
                .trim(from: 1 - progress, to: 1)
                .stroke(progressColor, style: StrokeStyle(lineWidth: 8, lineCap: .butt))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1.1), value: progress)
            
            Text("\(remaining)")
                .font(.system(size: 30, weight: .semibold))
        }
        .frame(width: 80, height: 80)
    }

    var progressColor: Color {
        if progress > 0.5 { return .green }
        if progress > 0.25 { return .orange }
        return .red
    }
}

#Preview {
    @Previewable @State var remaining: Int = 30
    TimerView(totalTime: 60, remaining: $remaining)
}
