//
//  Enums.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 08/03/26.
//

import Foundation

public enum HomeList: String, CaseIterable {
    case DSA = "Data Structures and Algorithms"
    case iOS = "iOS Development"
    case SYS = "System Design"
    case MGMT = "Management"
    case DTLS = "Details"
}

public enum PhtGroup: String, CaseIterable {
    case today = "Today"
    case yesterday = "Yesterday"
    case thisWeek = "This Week"
    case older = "Older"
}

public enum DifficultyLevel: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

public enum ProblemType: String, CaseIterable {
    case codingChallenge = "Coding Challenge"
    case interviewQuestion = "Interview Question"
}
