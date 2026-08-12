import UIKit
//https://leetcode.com/problems/binary-search/

//var greeting = "Hello, playground"

func search(_ nums: [Int], _ target: Int) -> Int {
    var response: Int = -1
    if (nums.contains(target)) {
        response = nums.firstIndex(of: target)!
    }
    return response
}

print(search([-1,0,3,5,9,12], 2))
