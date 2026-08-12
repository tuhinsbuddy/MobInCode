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
        typealias rawString = String
        case twoSum = "Two Sum"
        case binSear = "Binary Search"
        case buySell = "Buy and Sell Stock"
        case mrgSArr = "Merge Sorted Arrays"
        case rmvDupls = "Remove Duplicates from Sorted Array"
        case rmvElmts = "Remove Elements"
        case vldPal = "Valid Palindrome"
        
        var fileName: String {
            switch self {
                case .binSear: return "Binary_Search_Easy"
                case .buySell: return "Buy_Sell_Stock_Easy"
                case .mrgSArr: return "Merge_Sorted_Array_Easy"
                case .rmvDupls: return "Remove_Duplicate_Easy"
                case .twoSum: return "Two_Sum_Easy"
                case .rmvElmts: return "Remove_Element_Easy"
                case .vldPal: return "Valid_Palindrome_Easy"
            }
        }
    }
    
    enum DSAMedium: String {
        typealias rawString = String
        case twoSum = "Two Sum"
        
    }
    
    enum DSAHard: String {
        typealias rawString = String
        case twoSum = "Two Sum"
    }
}
