//
//  ContactsViewModel.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 11/08/26.
//
import Foundation
import Combine

@MainActor
final class ContactsViewModel: ObservableObject {
    @Published private(set) var contacts: [Contact] = []
    @Published private(set) var filteredContacts: [Contact] = []
    @Published var searchText: String = ""
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    private let repository: ContactsRepoProtocol
    private var searchTask: Task<Void, Never>?
    
    init(repo: ContactsRepoProtocol) {
        self.repository = repo
    }
    
    func loadContacts() async {
        self.isLoading = true
        self.errorMessage = nil
        defer {
            self.isLoading = false
        }
        do {
            self.contacts = try await repository.fetchContacts()
            self.filteredContacts = self.contacts
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func search() {
        self.searchTask?.cancel()
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        searchTask = Task {
            do {
                try await Task.sleep(for: .milliseconds(300))
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            if query.isEmpty {
                filteredContacts = contacts
                return
            }
            let rawContacts: [Contact] = contacts
            let results = await Task.detached(priority: .userInitiated) {
                return rawContacts.filter { contact in
                    contact.firstName.lowercased().contains(query) || contact.lastName.lowercased().contains(query) || contact.email.lowercased().contains(query) || contact.phone.lowercased().contains(query)
                }
            }.value
            guard !Task.isCancelled else { return }
            self.filteredContacts = results
        }
    }
    
    deinit {
        self.searchTask?.cancel()
    }
}

