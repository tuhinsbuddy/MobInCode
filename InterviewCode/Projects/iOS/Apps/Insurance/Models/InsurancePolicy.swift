//
//  InsurancePolicy.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 19/07/26.
//

import Foundation

struct InsurancePolicy: Identifiable, Codable {
    let id: String
    let type: String
    let provider: String
    let premium: Decimal
    let currency: String
    let status: PolicyStatus
    let startDate: Date
    let endDate: Date
    let vehicleNumber: String?
    let isRenewable: Bool
}
