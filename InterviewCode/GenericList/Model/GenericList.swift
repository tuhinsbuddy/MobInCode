//
//  GenericList.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 12/08/26.
//

import Foundation

struct GenericList: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let category: String
    let difficulty: String
    let description: String
    let status: String
    let route: String
}
