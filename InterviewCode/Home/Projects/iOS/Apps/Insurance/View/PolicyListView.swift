//
//  PolicyListView.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 19/07/26.
//

import SwiftUI

struct PolicyListView: View {
    @StateObject
    private var vm = PolicyListViewModel(repo: PolicyRepository())
    
    init(repo: PolicyRepository) {
        _vm = StateObject(wrappedValue: PolicyListViewModel(repo: repo))
    }
    
    var body: some View {
        NavigationStack {
            content.navigationTitle("My Policies").task {
                await vm.loadPolicies()
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle:
            Color.clear
        case .loading:
            ProgressView("Loading Policies...")
        case .empty:
            ContentUnavailableView(
                "No Policies",
                systemImage: "doc.text.magnifyingglass",
                description: Text("Your Policies will Appear Here!")
            )
        case .loaded(policies: let policies):
            List(policies) { policy in
                PolicyRow(policy: policy)
            }.listStyle(.plain)
        case .failed(msg: let message):
            VStack(spacing: 15) {
                Text(message).multilineTextAlignment(.center)
                Button("Retry") {
                    Task {
                        await vm.loadPolicies()
                    }
                }
            }.padding()
        }
    }
}
