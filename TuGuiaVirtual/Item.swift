//
//  Item.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 25/5/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
