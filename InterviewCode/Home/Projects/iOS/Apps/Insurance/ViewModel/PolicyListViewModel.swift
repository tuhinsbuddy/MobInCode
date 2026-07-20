//
//  PolicyListViewModel.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 19/07/26.
//
import Foundation
import Combine

@MainActor
final class PolicyListViewModel: ObservableObject {
    @Published private(set) var state: PolicyListState = .idle
    
    private let repository: PolicyRepoProtocol
    
    init(repo: PolicyRepoProtocol) {
        self.repository = repo
    }
    
    func loadPolicies() async {
        state = .loading
        do {
            let response = try await repository.fetchPolicies()
            if response.isEmpty {
                state = .empty
            } else {
                state = .loaded(policies: response)
            }
        } catch is CancellationError {
            
        } catch {
            state = .failed(msg: error.localizedDescription)
        }
        
    }
}
