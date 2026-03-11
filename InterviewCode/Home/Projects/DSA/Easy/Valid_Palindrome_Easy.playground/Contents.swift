import Foundation

//https://leetcode.com/problems/valid-palindrome/description/

//Brute Force
func isPalBrute(_ s: String) -> Bool {
    var response: Bool = false
    let strArr = s.lowercased().filter { char in
        ("a" ... "z").contains(char) || ("0" ... "9").contains(char)
    }
    let arr = Array(strArr)
    var start: Int = 0
    var end: Int = arr.count - 1
    
    while (start < end) {
        if arr[start] == arr[end] {
            start += 1
            end -= 1
            response = true
        } else {
            return response
        }
    }
    print(strArr)
    return response
}

//Using Swift
func isPalSwift(_ s: String) -> Bool {
    let lowerCasedString = s.lowercased()
    let filteredString = lowerCasedString.filter { ("a"..."z").contains($0) || ("0"..."9").contains($0) }
    let reversedString = String(filteredString.reversed())
    
    return filteredString == reversedString
}

let str: String = "A man, a plan, a canal: Panama"
print(isPalSwift(str))
print(isPalBrute(str))
