//
//  GenericListViewModel.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 12/08/26.
//

import Foundation
import Combine

@MainActor
final class GenericListViewModel: ObservableObject {
    @Published private(set) var topics: [Topic] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    private let repository: GenericListRepoProtocol
    
    init(repo: GenericListRepoProtocol) {
        self.repository = repo
    }
    
    func loadTopics() async {
        guard topics.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        do {
            let section = try await repository.fetchTopics()
            topics = section.topics
        } catch {
            errorMessage = "Failed to fetch topics!"
        }
    }
}
