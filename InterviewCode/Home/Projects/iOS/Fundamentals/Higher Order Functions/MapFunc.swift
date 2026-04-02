//
//  MapFunc.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 02/04/26.
//
import Foundation

struct MapFunc {
    static func getMap(fromData data: [UserInfo]) -> [UserInfo]? {
        var response: [UserInfo]?
        guard !data.isEmpty else { return response }
        response = data.map { $0.age > 18 }
    }
}
