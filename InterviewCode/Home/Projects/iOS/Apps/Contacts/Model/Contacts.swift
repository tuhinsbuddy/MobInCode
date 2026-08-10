//
//  Contacts.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 10/08/26.
//

import Foundation

struct Contacts: Identifiable, Codable, Hashable {
    let id: Int
    let firstName: String
    let lastName: String
    let phone: String
    let email: String
    var fullName: String {
        guard !firstName.isEmpty, !lastName.isEmpty else { return "" }
        return "\(firstName)\(lastName)"
    }
    var initials: String {
        let first: String = firstName.first.map(String.init) ?? ""
        let last: String = lastName.first.map(String.init) ?? ""
        return (first + last)
    }
}
