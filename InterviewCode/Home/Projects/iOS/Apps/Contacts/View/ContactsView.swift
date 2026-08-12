//
//  ContactsView.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 11/08/26.
//

import SwiftUI

struct ContactsView: View {
    @StateObject private var vm: ContactsViewModel = ContactsViewModel(repo: ContactsRepository())
    
    init(repo: ContactsRepoProtocol) {
        _vm = StateObject(wrappedValue: ContactsViewModel(repo: repo))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Loading Contacts...")
                } else if let errorMsg = vm.errorMessage {
                    errorView(message: errorMsg)
                } else if vm.filteredContacts.isEmpty && !vm.searchText.isEmpty {
                    noResult()
                } else {
                    contactsList
                }
            }
            .navigationTitle("Contacts")
            .searchable(text: $vm.searchText, prompt: "Search Contacts")
            .onChange(of: vm.searchText) {
                vm.search()
            }
            .task {
                await vm.loadContacts()
            }
        }
    }
    private var contactsList: some View {
        List(vm.filteredContacts) { contact in
            ContactRow(contact: contact)
        }.listStyle(.plain)
    }
    
    private func errorView(message msg: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
            Text(msg).multilineTextAlignment(.center)
            Button("Retry") {
                Task {
                    await vm.loadContacts()
                }
            }
        }.padding()
    }
    
    private func noResult() -> some View {
        VStack(spacing: 16) {
            Text("No Contacts Found").font(.headline)
            Text("Try searching different name, phone or email!").font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }.padding()
    }
}
