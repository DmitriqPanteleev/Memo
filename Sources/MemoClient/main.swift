import Foundation
import Memo

class Test {
    @Memo
    func factorial(value: Int) {
        if value == 1 {
            return 1
        }
        
        return value * factorial(value: value - 1)
    }
}

let test = Test()
print(test.memoFactorial(value: 5))
