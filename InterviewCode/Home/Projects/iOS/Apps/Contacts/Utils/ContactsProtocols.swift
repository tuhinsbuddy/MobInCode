//
//  ContactsProtocols.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 12/08/26.
//
import Foundation

protocol ContactsRepoProtocol {
    func fetchContacts() async throws -> [Contact]
}
