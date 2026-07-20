//
//  PolicyRepository.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 19/07/26.
//

import Foundation

final class PolicyRepository: PolicyRepoProtocol {
    func fetchPolicies() async throws -> [InsurancePolicy] {
        try await Task.sleep(for: .seconds(1))
        guard let path = Bundle.main.url(forResource: "Policies_Success", withExtension: "json") else {
            throw PolicyRepoError.fileNotFound
        }
        let data = try Data(contentsOf: path)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(PolicyResponse.self, from: data)
        return response.policies
    }
}
