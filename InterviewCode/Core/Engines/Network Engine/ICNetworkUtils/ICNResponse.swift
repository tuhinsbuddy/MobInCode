//
//  ICNResponse.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 19/03/26.
//

import Foundation

struct ICNResponse: Decodable {
    private(set) var httpCode: Int
    
    init(code: Int) {
        self.httpCode = code
    }
}
