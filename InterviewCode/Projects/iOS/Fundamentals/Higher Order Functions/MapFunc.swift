//
//  MapFunc.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 02/04/26.
//
import Foundation

struct MapFunc {
    /// Description
    /// - Parameter data: Array of `UserInfo`
    /// - Returns: Mapped `UserInfo` in an array where user's age is greater than or equals to 18 years.
    static func getMappedName(fromData data: [UserInfo]) -> [String]? {
        var response: [String]?
        guard !data.isEmpty else { return response }
        response = data.map { $0.name }
        return response
    }
}
