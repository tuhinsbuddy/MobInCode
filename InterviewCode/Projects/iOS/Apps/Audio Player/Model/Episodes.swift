//
//  Episodes.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 18/08/26.
//

import Foundation

struct Episodes: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let duration: TimeInterval
    let artwork: URL?
    let audioURL: URL
}
