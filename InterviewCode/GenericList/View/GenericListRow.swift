//
//  GenericListRow.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 12/08/26.
//

import SwiftUI

struct GenericListRow: View {
    let topic: Topic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(topic.title).font(.headline)
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
            }
            Text(topic.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            HStack(spacing: 8) {
                Text(topic.category)
                Text(".")
                Text(topic.difficulty)
                Spacer()
                if topic.status == "in_progress" {
                    Text("In Progress")
                }
            }.font(.caption).foregroundStyle(.secondary)
        }.padding(.vertical, 6)
    }
}
