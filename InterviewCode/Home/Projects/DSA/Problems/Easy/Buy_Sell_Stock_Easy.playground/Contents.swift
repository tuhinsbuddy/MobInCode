import UIKit

//var greeting = "Hello, playground"

//LeetCode Link - https://leetcode.com/problems/best-time-to-buy-and-sell-stock/description/

func buyStock(prices arr: [Int]) -> Int { //[7, 1, 5, 3, 6, 4]
    var profit: Int = 0
    guard arr.count > 1 else { return profit }
    var buyAt: Int = 0
    
    for (index, value) in arr.enumerated() {
        if index == 0 {
            buyAt = value
        } else {
            if (buyAt > value) { //7 > 1 = 1
                buyAt = value
            } else if ((value - buyAt) > profit){ //5 - 1 = 4
                profit = (value - buyAt)
            }
        }
    }
    return profit
}

print(buyStock(prices: [7, 1, 5, 3, 6, 4]))
