//
//  Topics.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 18/08/26.
//

import Foundation

struct Topic: Identifiable, Decodable, Hashable {
    let id: Int
    let title: String
    let category: String
    let difficulty: String
    let description: String
    let status: String
    let route: String
}

struct TopicSection: Decodable {
    let id: String
    let title: String
    let subtitle: String
    let topics: [Topic]
}

struct TopicResponse: Decodable {
    let section: TopicSection
}
