//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
import Combine
@testable import NowNowNow

class URLStatusView_ViewModel: XCTestCase {
    typealias ViewModel = URLStatusView.ViewModel
    typealias Status = ViewModel.Status

    var irrelevantURL: URL { URL(fileURLWithPath: "/tmp") }
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        cancellables = []
    }

    override func tearDownWithError() throws {
        cancellables = []
    }

    func testConvenienceInitFromURLAndPending() throws {
        // Note: we cannot get back to `.initial` by design.
        XCTAssertEqual(Status(url: nil, isPending: false), .invalid)
        XCTAssertEqual(Status(url: nil, isPending: true), .pending)
        XCTAssertEqual(Status(url: irrelevantURL, isPending: false), .valid)
        XCTAssertEqual(Status(url: irrelevantURL, isPending: true), .pending)
    }

    func testStatus_WithoutURL_PerformingNetworkActivity_ProducesPendingStatus() throws {
        let viewModel = ViewModel(
            validURL: Publishers.Sequence<[URL?], Never>(sequence: [nil]).delay(for: 0.1, scheduler: RunLoop.main).eraseToAnyPublisher(),
            isPerformingNetworkActivity: Publishers.Sequence<[Bool], Never>(sequence: [true]).delay(for: 0.1, scheduler: RunLoop.main).eraseToAnyPublisher())

        let statusReceivedExpectation = expectation(description: "Receives status update")
        viewModel
            .$status
            .collect(2)
            .sink { values in
                XCTAssertEqual(values, [.initial, .pending])
                statusReceivedExpectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1, handler: nil)
    }
}
