import Foundation

//Leetcode - https://leetcode.com/problems/ransom-note/description/?envType=study-plan-v2&envId=top-interview-150

//Brute Force using Swift
//func canConstruct(_ ransomNote: String, _ magazine: String) -> Bool {
//    guard !ransomNote.isEmpty, !magazine.isEmpty else { return false }
//    return magazine.contains(ransomNote)
//}

//Brute Force using DS
func canConstruct(_ ransomNote: String, _ magazine: String) -> Bool {
    var response: Bool = true
    guard !ransomNote.isEmpty, !magazine.isEmpty else { return false }
    var checkDict: [Character: Int] = [:]
    for magVal in magazine {
        checkDict[magVal] = (checkDict[magVal] ?? 0) + 1
    }
    for ranVal in ransomNote {
        if checkDict[ranVal] == nil || (checkDict[ranVal] ?? 0) <= 0{
            response = false
            break
        } else {
            checkDict[ranVal] = (checkDict[ranVal] ?? 0) - 1
        }
    }
    
    return response
}

let ransomNote: String = "aac"
let magazine: String = "baabc"
print(canConstruct(ransomNote, magazine))
