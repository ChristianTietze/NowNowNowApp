//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
import Combine
import Foundation
@testable import NowNowNow

class URLStatusViewViewModelTests: XCTestCase {
    typealias ViewModel = URLStatusView.ViewModel
    
    class URLResolverDouble {
        let receivedURLStringExpectation: XCTestExpectation
        private(set) var receivedString: String?

        init(receivedURLStringExpectation: XCTestExpectation) {
            self.receivedURLStringExpectation = receivedURLStringExpectation
        }

        func urlResolver(returning urlResult: URL?) -> ViewModel.URLResolver {
            return { string, activityPublisher in
                self.receivedString = string
                self.receivedURLStringExpectation.fulfill()

                activityPublisher.send(true)
                defer { activityPublisher.send(false) }

                return Just(urlResult).eraseToAnyPublisher()
            }
        }
    }

    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        cancellables = []
    }

    override func tearDownWithError() throws {
        cancellables = []
    }

    func testInitialValues() {
        let validator = ViewModel(reachableURL: { _, _ in Just(URL?.none).eraseToAnyPublisher() })

        XCTAssertEqual(validator.isPerformingNetworkActivity, false)
        XCTAssertEqual(validator.text, "")
        XCTAssertEqual(validator.validURL, nil)
    }

    func testValidURL_WithInvalidURLString_PerformsRequestsAndFails() throws {
        let receivedURLStringExpectation = expectation(description: "Receives URL input")
        let requestHandlerDouble = URLResolverDouble(receivedURLStringExpectation: receivedURLStringExpectation)
        let validator = ViewModel(reachableURL: requestHandlerDouble.urlResolver(returning: nil))

        let isPerformingNetworkActivityExpectation = expectation(description: "Changes network activity status twice")
        validator
            .$isPerformingNetworkActivity
            .dropFirst()
            .collect(2)
            .sink { values in
                XCTAssertEqual(values, [true, false])
                isPerformingNetworkActivityExpectation.fulfill()
            }
            .store(in: &cancellables)

        let validURLReceivedExpectation = expectation(description: "Receives validURL update")
        validator
            .$validURL
            .dropFirst()
            .collect(2)
            .sink { values in
                XCTAssertEqual(values, [nil, nil])
                validURLReceivedExpectation.fulfill()
            }
            .store(in: &cancellables)

        validator.text = "invalid url"

        wait(for: [
            receivedURLStringExpectation,
            isPerformingNetworkActivityExpectation,
            validURLReceivedExpectation
        ], timeout: 1)

        XCTAssertEqual(requestHandlerDouble.receivedString, "invalid url")
    }

    func testValidURL_WithValidURLString_PerformsRequestsAndProducesURL() throws {
        let urlStub = URL(fileURLWithPath: "/a/valid/url/")
        let receivedURLStringExpectation = expectation(description: "Receives URL input")
        let requestHandlerDouble = URLResolverDouble(receivedURLStringExpectation: receivedURLStringExpectation)
        let validator = ViewModel(reachableURL: requestHandlerDouble.urlResolver(returning: urlStub))

        let isPerformingNetworkActivityExpectation = expectation(description: "Changes network activity status twice")
        validator
            .$isPerformingNetworkActivity
            .dropFirst()
            .collect(2)
            .sink { values in
                XCTAssertEqual(values, [true, false])
                isPerformingNetworkActivityExpectation.fulfill()
            }
            .store(in: &cancellables)

        let validURLReceivedExpectation = expectation(description: "Receives validURL update")
        validator
            .$validURL
            .dropFirst()
            .collect(2)
            .sink { values in
                XCTAssertEqual(values, [nil, urlStub])
                validURLReceivedExpectation.fulfill()
            }
            .store(in: &cancellables)

        validator.text = "some valid url"

        wait(for: [
            receivedURLStringExpectation,
            isPerformingNetworkActivityExpectation,
            validURLReceivedExpectation
        ], timeout: 1)

        XCTAssertEqual(requestHandlerDouble.receivedString, "some valid url")
    }
}
