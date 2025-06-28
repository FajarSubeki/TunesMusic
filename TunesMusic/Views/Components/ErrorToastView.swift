//
//  ErrorToastView.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import SwiftUI

struct ErrorToastView: View {
    let message: String

    var body: some View {
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
    }
}
