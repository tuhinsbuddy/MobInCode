//
//  FilterFunc.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 02/04/26.
//
import Foundation

struct FilterFunc {
    static func getFiltered(fromData data: [UserInfo]) -> [UserInfo]? {
        var response: [UserInfo]?
        guard !data.isEmpty else { return response }
        response = data.filter({ element in
            return element.age >= 18
        })
        return response
    }
}
