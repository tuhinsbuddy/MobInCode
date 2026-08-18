//
//  GenericListView.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 12/08/26.
//

import SwiftUI

struct GenericListView: View {
    @StateObject private var vm: GenericListViewModel
    @EnvironmentObject private var router: ICREngine
    let title: String
    
    
    init(repo: GenericListRepoProtocol, title: String) {
        _vm = StateObject(wrappedValue: GenericListViewModel(repo: repo))
        self.title = title
    }
    
    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading Topics...")
            } else if let errorMsg = vm.errorMessage {
                
            } else if vm.topics.isEmpty {
                emptyView
            } else {
                
            }
        }.navigationTitle(title)
            .task {
                await vm.loadTopics()
            }
    }
    
    private var topicList: some View {
        List(vm.topics) { topic in
            Button {
                didSelect(with: topic)
            } label: {
//                Topicr
            }
        }
    }
    
    
    
}

extension GenericListView {
    private func didSelect(with topic: Topic) {
        switch topic.route {
        case "contacts":
            router.navigate(to: .contacts)
        default:
            Alert(title: Text("Coming Soon!"))
        }
    }
    
    private func errorView(msg: String) -> some View {
        ContentUnavailableView {
            Label("Unable to Load", systemImage: "exclamationmark.triangle")
        } description: {
            Text(msg)
        } actions: {
            Button("Retry") {
                Task {
                    await vm.loadTopics()
                }
            }
        }
    }
    
    private var emptyView: some View {
        ContentUnavailableView("No Topics", systemImage: "list.bullet", description: Text("There are currrently no topic available!"))
    }
}
