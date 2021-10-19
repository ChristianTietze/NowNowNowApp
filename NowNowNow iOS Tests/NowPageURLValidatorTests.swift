//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
import Combine
import Foundation
@testable import NowNowNow

class NowPageURLValidatorTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        cancellables = []
    }

    override func tearDownWithError() throws {
        cancellables = []
    }

    func testValidURL_WithInvalidURLString_PerformsRequestsAndFails() throws {
        // Given
        let receivedURLStringExpectation = expectation(description: "Receives URL input")
        var receivedString: String?
        let urlResolverDouble: NowPageURLValidator.URLResolver = { string, activityPublisher in
            receivedString = string
            receivedURLStringExpectation.fulfill()

            activityPublisher.send(true)
            defer { activityPublisher.send(false) }

            return Just(URL?.none).eraseToAnyPublisher()
        }
        let validator = NowPageURLValidator(reachableURL: urlResolverDouble)
        XCTAssertEqual(validator.isPerformingNetworkActivity, false)

        // Then
        var isPerformingNetworkActivityCount = 0
        let isPerformingNetworkActivityExpectation = expectation(description: "Changes network activity status twice")
        validator
            .$isPerformingNetworkActivity
            .dropFirst()
            .sink { value in
                isPerformingNetworkActivityCount += 1
                if isPerformingNetworkActivityCount == 1 {
                    XCTAssertEqual(value, true)
                } else if isPerformingNetworkActivityCount == 2 {
                    XCTAssertEqual(value, false)
                    isPerformingNetworkActivityExpectation.fulfill()
                } else {
                    XCTFail("Expected isPerformingNetworkActivityCount to be changed only 2x")
                }
            }
            .store(in: &cancellables)

        var validURLReceivedCount = 0
        let validURLReceivedExpectation = expectation(description: "Receives validURL update")
        validator
            .$validURL
            .dropFirst()
            .sink { value in
                validURLReceivedCount += 1
                if validURLReceivedCount == 1 {
                    XCTAssertNil(value)
                } else if validURLReceivedCount == 2 {
                    XCTAssertNil(value)
                    validURLReceivedExpectation.fulfill()
                } else {
                    XCTFail("Expected validURL to be changed only 2x")
                }
            }.store(in: &cancellables)

        // When
        validator.text = "invalid url"

        wait(for: [
            receivedURLStringExpectation,
            isPerformingNetworkActivityExpectation,
            validURLReceivedExpectation
        ], timeout: 1)

        XCTAssertEqual(receivedString, "invalid url")
    }

    func testValidURL_WithValidURLString_PerformsRequestsAndProducesURL() throws {
        // Given
        let urlStub = URL(fileURLWithPath: "/a/valid/url/")
        let receivedURLStringExpectation = expectation(description: "Receives URL input")
        var receivedString: String?
        let urlResolverDouble: NowPageURLValidator.URLResolver = { string, activityPublisher in
            receivedString = string
            receivedURLStringExpectation.fulfill()

            activityPublisher.send(true)
            defer { activityPublisher.send(false) }

            return Just(urlStub).eraseToAnyPublisher()
        }
        let validator = NowPageURLValidator(reachableURL: urlResolverDouble)
        XCTAssertEqual(validator.isPerformingNetworkActivity, false)

        var isPerformingNetworkActivityCount = 0
        let isPerformingNetworkActivityExpectation = expectation(description: "Changes network activity status twice")
        validator
            .$isPerformingNetworkActivity
            .dropFirst()
            .sink { value in
                isPerformingNetworkActivityCount += 1
                if isPerformingNetworkActivityCount == 1 {
                    XCTAssertEqual(value, true)
                } else if isPerformingNetworkActivityCount == 2 {
                    XCTAssertEqual(value, false)
                    isPerformingNetworkActivityExpectation.fulfill()
                } else {
                    XCTFail("Expected isPerformingNetworkActivityCount to be changed only 2x")
                }
            }
            .store(in: &cancellables)

        var validURLReceivedCount = 0
        let validURLReceivedExpectation = expectation(description: "Receives validURL update")
        validator
            .$validURL
            .dropFirst()
            .sink { value in
                validURLReceivedCount += 1
                if validURLReceivedCount == 1 {
                    XCTAssertNil(value)
                } else if validURLReceivedCount == 2 {
                    XCTAssertEqual(value, urlStub)
                    validURLReceivedExpectation.fulfill()
                } else {
                    XCTFail("Expected validURL to be changed only 2x")
                }
            }.store(in: &cancellables)

        // When
        validator.text = "some valid url"

        wait(for: [
            receivedURLStringExpectation,
            isPerformingNetworkActivityExpectation,
            validURLReceivedExpectation
        ], timeout: 1)

        XCTAssertEqual(receivedString, "some valid url")
    }

}
