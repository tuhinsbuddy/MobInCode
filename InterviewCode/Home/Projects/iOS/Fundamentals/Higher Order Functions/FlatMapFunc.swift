//
//  FlatMapFunc.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 02/04/26.
//

//Flatten Nested Collections. Can apply custom calculations.
//Deprecated due to optional confusion. compactMap is being used currently.
struct FlatMapFunc {
    static func getFlatMap(ofData data: [[Any]]) -> [Any]? {
        var response: [Any]?
        guard data.isEmpty else { return response }
        response = data.flatMap({ element in
            return element
        })
        return response
    }
}
