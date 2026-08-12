//
//  ContactsRepository.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 10/08/26.
//

import Foundation

final class ContactsRepository: ContactsRepoProtocol {
    func fetchContacts() async throws -> [Contact] {
        guard let path = CoreFunc.getLocalJSON(for: "contacts") else {
            throw ICREnums.fileNotFound
        }
        return try await Task.detached(priority: .userInitiated) {
            let data = try Data(contentsOf: path)
            return try JSONDecoder().decode([Contact].self, from: data)
        }.value
    }
}
