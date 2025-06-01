//
//  Buttons.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 1/6/25.
//

import SwiftUI

struct SearchButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label("Buscar lugares", systemImage: "magnifyingglass")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 3)
        }
        .padding(.horizontal)
    }
}
