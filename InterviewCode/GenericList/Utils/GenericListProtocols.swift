//
//  GenericListProtocols.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 12/08/26.
//

import Foundation

protocol GenericListRepoProtocol {
    func getList() async throws -> [GenericList]
    func fetchTopics() async throws -> TopicSection
}
