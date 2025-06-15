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
            HStack {
                Image(systemName: "magnifyingglass")
                Text("Buscar lugares")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.accentColor)
                    .shadow(color: Color.accentColor.opacity(0.3), radius: 5, x: 0, y: 3)
            )
            .foregroundColor(.white)
        }
    }
}

#Preview {
    SearchButton(action: {})
        .padding()
        
}


