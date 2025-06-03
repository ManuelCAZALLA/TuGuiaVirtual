//
//  NearbyButton.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 1/6/25.
//

import SwiftUI

struct NearbyButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label("Cerca de mí", systemImage: "location.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 3)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NearbyButton(action: {})
}
