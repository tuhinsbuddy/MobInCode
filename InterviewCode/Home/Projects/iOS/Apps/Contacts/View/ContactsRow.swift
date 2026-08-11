//
//  ContactsRow.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 11/08/26.
//

import SwiftUI

struct ContactRow: View {
    let contact: Contact
    
    var body: some View {
        HStack(spacing: 12) {
            Circle().fill(.gray.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay {
                    Text(contact.initials).font(.headline)
                }
            VStack(alignment: .leading, spacing: 4) {
                Text(contact.fullName).font(.headline)
                Text(contact.phone).font(.subheadline).foregroundStyle(.secondary)
                Text(contact.email).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }.padding(.vertical, 4)
    }
}
