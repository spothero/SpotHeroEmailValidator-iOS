// Copyright © 2022 SpotHero, Inc. All rights reserved.

import Foundation

public extension String {
    /// Returns the minimum number of operations to edit this string into another string.
    ///
    /// Source: [Minimum Edit Distance - Swift Algorithm Club](https://github.com/raywenderlich/swift-algorithm-club/tree/main/Minimum%20Edit%20Distance)
    /// - Parameter other: The other string to compare with.
    func levenshteinDistance(from other: String) -> Int {
        // swiftlint:disable identifier_name
        let m = self.count
        let n = other.count
        var matrix = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: m + 1)
        
        // initialize matrix
        for index in 1 ... m {
            // the distance of any first string to an empty second string
            matrix[index][0] = index
        }
        
        for index in 1 ... n {
            // the distance of any second string to an empty first string
            matrix[0][index] = index
        }
        
        // compute Levenshtein distance
        for (i, selfChar) in self.enumerated() {
            for (j, otherChar) in other.enumerated() {
                if otherChar == selfChar {
                    // substitution of equal symbols with cost 0
                    matrix[i + 1][j + 1] = matrix[i][j]
                } else {
                    // minimum of the cost of insertion, deletion, or substitution
                    // added to the already computed costs in the corresponding cells
                    matrix[i + 1][j + 1] = Swift.min(matrix[i][j] + 1, matrix[i + 1][j] + 1, matrix[i][j + 1] + 1)
                }
            }
        }
        // swiftlint:enable identifier_name
        return matrix[m][n]
    }
}
