//
//  ReduceFunc.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 02/04/26.
//
import Foundation

struct ReduceFunc {
    static func getReduced(ofData data: [UserInfo]) -> Int? {
        var response: Int?
        guard !data.isEmpty else { return response }
        response = data.reduce(20, { $0 + ($1.age ?? 0) })
        return response
    }
}
