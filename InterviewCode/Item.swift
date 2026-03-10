//
//  Item.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 07/03/26.
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
