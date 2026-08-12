//
//  CompactMapFunc.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 02/04/26.
//
import Foundation

struct CompactMapFunc {
    static func getCompactMap(ofData data: [UserInfo]) -> [UserInfo]? {
        var response: [UserInfo]?
        guard !data.isEmpty else { return response }
        response = data.compactMap { $0 }
        return response
    }
}
