//
//  LoadingIndicatorView.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 8/6/25.
//

import SwiftUI

struct LoadingIndicator: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(2)
            
    }
}

#Preview {
    LoadingIndicator()
}
