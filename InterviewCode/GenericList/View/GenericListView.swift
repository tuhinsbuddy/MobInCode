//
//  GenericListView.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 12/08/26.
//

import SwiftUI

struct GenericListView: View {
    @StateObject private var vm: GenericListViewModel
    
    init(repo: GenericListRepoProtocol) {
        _vm = StateObject(wrappedValue: GenericListViewModel(repo: repo))
    }
    
    var body: some View {
        Text("Hello, World!")
    }
}
