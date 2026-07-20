//
//  PolicyRow.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 20/07/26.
//

import SwiftUI

struct PolicyRow: View {
    let policy: InsurancePolicy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(policy.type).font(.headline)
                    Text(policy.provider).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                statusBadge
            }
            Text(formattedPremium).font(.title3).fontWeight(.semibold)
            Text("Expires \(policy.endDate.formatted(date: .abbreviated, time: .omitted))").font(.caption).foregroundStyle(.secondary)
            if let vehicleNumber = policy.vehicleNumber, !vehicleNumber.isEmpty {
                Text("Vehicle: \(vehicleNumber)").font(.caption).foregroundStyle(.secondary)
            }
        }.padding(.vertical, 6)
    }
    
    private var formattedPremium: String {
        let amount = NSDecimalNumber(decimal: policy.premium)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = policy.currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: amount) ?? "\(policy.currency) \(policy.premium)"
    }
    
    @ViewBuilder
    private var statusBadge: some View {
        Text(policy.status.displayName).font(.caption)
            .fontWeight(.semibold).padding(.horizontal, 10)
            .padding(.vertical, 5).background(.thinMaterial)
            .clipShape(Capsule())
    }
}
