//
//  SearchBarView.swift
//  TunesMusic
//
//  Created by Fajar Subeki on 28/06/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var onSearch: () -> Void
    @State private var searchWorkItem: DispatchWorkItem?

    var body: some View {
        
        TextField("Search artist", text: $text, onCommit: onSearch)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 13)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)
            .onChange(of: text, initial: false) {_, newText in
                searchWorkItem?.cancel()
                if newText.count >= 2 {
                    let task = DispatchWorkItem {
                        onSearch()
                    }
                    searchWorkItem = task
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
                }
            }

    }
}


