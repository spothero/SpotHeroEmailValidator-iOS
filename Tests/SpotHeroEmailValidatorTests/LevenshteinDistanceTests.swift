//  Copyright © 2019 SpotHero, Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

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
