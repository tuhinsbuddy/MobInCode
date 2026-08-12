import Foundation

//Leetcode - https://leetcode.com/problems/remove-duplicates-from-sorted-array/description/?envType=study-plan-v2&envId=top-interview-150

//Brute Force
//func removeDuplicates(_ nums: inout [Int]) -> Int {
//    guard !nums.isEmpty else { return 0 }
//    var response: [Int: Int] = [:]
//    for value in nums {
//        print(value)
//        if response[value] == nil {
//            print("Adding - \(value)")
//            response[value] = value
//        }
//    }
//    print(response)
//    return response.count
//}
//


//Brute Force - Not working at all.
//func removeDuplicates(_ nums: inout [Int]) -> Int {
//    guard !nums.isEmpty else { return 0 }
//    var response: [Int] = []
//    var lastValue: Int = 0
//    for index in 0..<nums.count {
//        guard ((index + 1) != nums.count) else { break }
//        if (lastValue != nums[index]), (nums[index] == nums[(index + 1)]) {
//            response.append(nums[index])
//            lastValue = nums[index]
//        }
//    }
//    return response.count
//}

//Optimised Solution - Two pointers. Fast and Slow

func removeDuplicates(_ nums: inout [Int]) -> Int {
    guard nums.count > 1 else { return 0 }
    var slowIndex: Int = 1
    for fastIndex in 1..<nums.count {
        if (nums[fastIndex] != nums[(slowIndex - 1)]) {
         nums[slowIndex] = nums[fastIndex]
            slowIndex += 1
        }
    }
    return slowIndex
}


var data: [Int] = [0,0,1,1,1,2,2,3,3,4]
print(removeDuplicates(&data))
