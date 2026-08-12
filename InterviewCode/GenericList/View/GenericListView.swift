//
//  GenericListView.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 12/08/26.
//

import SwiftUI

struct GenericListView: View {
    @StateObject private var vm: GenericListViewModel
    
    init(vm: GenericListProtocols) {
        self.vm = vm
    }
    
    var body: some View {
        Text("Hello, World!")
    }
}
