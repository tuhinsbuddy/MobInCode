//
//  ContactsRepository.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 10/08/26.
//

import Foundation

protocol ContactsRepositoryProtocol {
    func fetchContacts() async throws -> [Contacts]
}

final class ContactsRepository: ContactsRepositoryProtocol {
    func fetchContacts() async throws -> [Contacts] {
        guard let path = CoreFunc.getLocalJSON(for: "contacts") else {
            throw ICREnums.fileNotFound
        }
        let data = try Data(contentsOf: path)
        return try JSONDecoder().decode([Contacts].self, from: data)
    }
}
