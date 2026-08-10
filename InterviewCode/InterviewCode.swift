//
//  InterviewCode.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 07/03/26.
//

import SwiftUI
import SwiftData

@main
struct InterviewCode: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Home()
//            PolicyListView(repo: PolicyRepository())
        }
        .modelContainer(sharedModelContainer)
    }
}
