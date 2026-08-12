//
//  PolicyEnum.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 19/07/26.
//

import Foundation

enum PolicyListState {
    case idle
    case loading
    case empty
    case loaded(policies: [InsurancePolicy])
    case failed(msg: String)
}

enum PolicyStatus: String, Codable {
    case active
    case expired
    case expiringSoon
    case suspended
    case revoked
    
    var displayName: String {
        switch self {
        case .active: return "Active"
        case .expired: return "Expired"
        case .expiringSoon: return "Expiring Soon"
        case .suspended: return "Suspended"
        case .revoked: return "Revoked"
        }
    }
}
