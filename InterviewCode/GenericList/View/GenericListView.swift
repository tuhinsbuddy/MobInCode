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
                
            }
        }
    }
    
    
}
