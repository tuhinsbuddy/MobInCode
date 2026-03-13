import Foundation

//Leetcode Link - https://leetcode.com/problems/remove-element/description/?envType=study-plan-v2&envId=top-interview-150

//Brute Force
func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
    let data: [Int] = nums.filter{ $0 != val }
    nums = data
    return data.count
}

var nums: [Int] = [3, 2, 2, 3]
let val: Int = 3
let response: Int = removeElement(&nums, val)

print("The count of non matching value is - \(response)")
print(nums)



// Pure DS Solution
func removeElementDS(_ nums: inout [Int], _ val: Int) -> Int {
    var k: Int = 0
    for index in 0..<nums.count {
        let value = nums[index]
        if value != val {
            nums[k] = value
            k += 1
        }
    }
    return k
}
