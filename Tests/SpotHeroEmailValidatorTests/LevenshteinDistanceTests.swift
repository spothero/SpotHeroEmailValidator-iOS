// Copyright © 2020 SpotHero, Inc. All rights reserved.

@testable import SpotHeroEmailValidator
import XCTest

class LevenshteinDistanceTests: XCTestCase {
    struct LevenshteinDistanceTestModel {
        var stringA: String
        var stringB: String
        var distance: Int
    }
    
    func testDistanceCategory() {
        let tests = [
            LevenshteinDistanceTestModel(stringA: "kitten", stringB: "sitting", distance: 3),
            LevenshteinDistanceTestModel(stringA: "testing", stringB: "lev", distance: 6),
            LevenshteinDistanceTestModel(stringA: "book", stringB: "back", distance: 2),
            LevenshteinDistanceTestModel(stringA: "spot", stringB: "hero", distance: 4),
            LevenshteinDistanceTestModel(stringA: "parking", stringB: "rules", distance: 6),
            LevenshteinDistanceTestModel(stringA: "lame", stringB: "same", distance: 1),
            LevenshteinDistanceTestModel(stringA: "same", stringB: "same", distance: 0),
        ]

        for test in tests {
            XCTAssertEqual(test.stringA.levenshteinDistance(from: test.stringB), test.distance)
            XCTAssertEqual(test.stringB.levenshteinDistance(from: test.stringA), test.distance)
        }
    }
}
