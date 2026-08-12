//
//  PolicyProtocols.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 19/07/26.
//

import Foundation

protocol PolicyRepoProtocol{
    func fetchPolicies() async throws -> [InsurancePolicy]
}
