//
//  ContactsViewModel.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 11/08/26.
//
import SwiftUI

@MainActor
final class ContactsViewModel: ObservableObject {
    @Published var contacts: [Contacts] = []
    @Published var filteredContacts: [Contacts] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repo: ContactsRepositoryProtocol
    private var searchTask: Task<Void, Never>?
    
    init(repo protocol: ContactsRepositoryProtocol = ContactsRepository()) {
        self.repo = protocol
    }
    
    func loadContacts() async {
        self.isLoading = true
        self.errorMessage = nil
        do {
            self.contacts = try await repo.fetchContacts()
            self.filteredContacts = self.contacts
        } catch {
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
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
//            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            if query.isEmpty {
                filteredContacts = contacts
                return
            }
            let rawContacts: [Contacts] = contacts
            let results = Task.detached(priority: .userInitiated) {
                return rawContacts.filter { contact in
                    <#code#>
                }
            }
            
            filteredContacts = contacts.filter({ contact in
                contact.firstName.lowercased().contains(query) || contact.lastName.lowercased().contains(query) || contact.email.lowercased().contains(query) || contact.phone.lowercased().contains(query)
            })
        }
    }
    
    
}
