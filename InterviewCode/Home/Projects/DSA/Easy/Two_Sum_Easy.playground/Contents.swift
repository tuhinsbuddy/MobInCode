import Foundation

// Link - https://leetcode.com/problems/two-sum/description/

func twoSum(of arr: [Int], target trgt: Int) {
    if arr.count < 2 { print("The source data is not in correct format"); return }
    var dictData: [Int: Int] = [:]
    for (index, value) in arr.enumerated() {
        let diff: Int = (trgt - value)
        if let storedValue = dictData[diff] {
            print("Two Sum is - [\(storedValue), \(index)]")
            break
        } else {
            dictData[value] = index
        }
    }
    
}

twoSum(of: [2, 7, 15, 11], target: 9)
