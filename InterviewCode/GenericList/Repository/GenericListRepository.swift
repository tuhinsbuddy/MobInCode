//
//  GenericListRepository.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 18/08/26.
//

import Foundation

struct GenericListRepository: GenericListRepoProtocol {
    func getList() async throws -> [GenericList] {
        
    }
    
    func fetchTopics() async throws -> TopicSection {
        guard let path = CoreFunc.getLocalJSON(for: "ios_feature_topics") else {
            throw ICREnums.fileNotFound
        }
        
        let response = try await Task.detached {
            let data = try Data(contentsOf: path)
            return try JSONDecoder().decode(TopicResponse.self, from: data)
        }.value
        return response.section
    }
}
