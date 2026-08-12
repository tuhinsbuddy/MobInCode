import Foundation

//LeetCode Link - https://leetcode.com/problems/merge-sorted-array/description/?envType=study-plan-v2&envId=top-interview-150

//Input: nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3
//Output: [1,2,2,3,5,6]
//Explanation: The arrays we are merging are [1,2,3] and [2,5,6].
//The result of the merge is [1,2,2,3,5,6] with the underlined elements coming from nums1.

//Brute Force or Using Swift Library
//func mergeSorted(nums1: inout [Int], m: Int, nums2: [Int], n: Int) {
//    var res: [Int] = nums1 + nums2
//    res = res.sorted(by: <).filter{ $0 > 0 }
//    print(res)
//

//    var response: [Int] = []
//    let testArr: [Int] = (m > n) ? nums1 : nums2
//    let isMGreater: Bool = (m > n)
//    var prevBig: Int = 0
//    for (index, value) in testArr.enumerated() {
//        if isMGreater {
//
//        } else {
//
//        }
//        if value > 0 { //Value is not 0
//            response.insert(<#T##newElement: Int##Int#>, at: <#T##Int#>)
//        } else { //Value is 0
//            response
//        }
//    }
//}
//var nums1: [Int] = [-1,0,0,3,3,3,0,0,0]
//mergeSorted(nums1: &nums1, m: 3, nums2: [2,5,6], n: 3)

//Optimal Solution
func mergeSortedArray(nums1: inout [Int], m: Int, nums2: [Int], n: Int) {
    var mIdx: Int = (m - 1)
    var nIdx: Int = (n - 1)
    var lastIdx: Int = ((m + n) - 1)
    
    while (nIdx >= 0) {
        if (mIdx >= 0), (nums1[mIdx] > nums2[nIdx]) {
            nums1[lastIdx] = nums1[mIdx]
            mIdx -= 1
        } else {
            nums1[lastIdx] = nums2[nIdx]
            nIdx -= 1
        }
        lastIdx -= 1
    }
}

var nums1: [Int] = [1, 2, 3, 0, 0, 0]
let mIndex: Int = 3
let nums2: [Int] = [2, 5, 6]
let nIndex: Int = 3

mergeSortedArray(nums1: &nums1, m: mIndex, nums2: nums2, n: nIndex)
print("The final array is - \(nums1)")


