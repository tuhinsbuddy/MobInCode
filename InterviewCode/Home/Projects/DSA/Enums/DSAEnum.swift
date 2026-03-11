//
//  DSAEnum.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 11/03/26.
//

import Foundation

public enum DSAList: String, CaseIterable {
    case str = "Strings"
    case arr = "Arrays"
    case lnklst = "Linked Lists"
    case dict = "Dictionaries"
    case heap = "Heaps"
    case graph = "Graphs"
}

public enum DSAProblems: CaseIterable {
    enum DSAEasy: String {
        typealias RawString = String
        case twoSum = "Two Sum"
        
        
    }
    
    enum DSAMedium: String {
        typealias RawString = String
        case twoSum = "Two Sum"
        
    }
    
    enum DSAHard: String {
        typealias RawString = String
        case twoSum = "Two Sum"
    }
}
