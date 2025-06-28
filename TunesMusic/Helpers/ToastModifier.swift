//
//  ToastModifier.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isVisible: Bool
    let message: String
    let duration: Double

    func body(content: Content) -> some View {
        ZStack {
            content

            if isVisible {
                VStack {
                    Spacer()
                    Text(message)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .cornerRadius(8)
                        .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isVisible = false
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func toast(message: String, isVisible: Binding<Bool>, duration: Double = 3.0) -> some View {
        self.modifier(ToastModifier(isVisible: isVisible, message: message, duration: duration))
    }
}
