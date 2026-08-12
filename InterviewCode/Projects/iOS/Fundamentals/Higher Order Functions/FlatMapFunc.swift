//
//  FlatMapFunc.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 02/04/26.
//
import Foundation

//Flatten Nested Collections. Can apply custom calculations.
//Deprecated due to optional confusion. compactMap is being used currently.
struct FlatMapFunc {
    static func getFlatMap(ofData data: [[UserInfo]]) -> [UserInfo]? {
        var response: [UserInfo]?
        guard !data.isEmpty else { return response }
        response = data.flatMap({ element in
            return element
        })
        return response
    }
}
