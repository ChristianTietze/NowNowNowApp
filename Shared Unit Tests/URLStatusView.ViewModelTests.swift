//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
import Combine
import EntwineTest
@testable import NowNowNow

class URLStatusView_ViewModel: XCTestCase {
    typealias ViewModel = URLStatusView.ViewModel
    typealias Status = ViewModel.Status

    var irrelevantURL: URL { URL(fileURLWithPath: "/tmp") }

    func testConvenienceInitFromURLAndPending() throws {
        // Note: we cannot get back to `.initial` by design.
        XCTAssertEqual(Status(url: nil, isPending: false), .invalid)
        XCTAssertEqual(Status(url: nil, isPending: true), .pending)
        XCTAssertEqual(Status(url: irrelevantURL, isPending: false), .valid)
        XCTAssertEqual(Status(url: irrelevantURL, isPending: true), .pending)
    }

    func testStatus_JustURL_ProducesValidStatus() throws {
        let testScheduler = TestScheduler(initialClock: 0)
        let validURLPublisher: TestablePublisher<URL?, Never> = testScheduler.createRelativeTestablePublisher([
            (444, .input(irrelevantURL))
        ])
        let isPerformingNetworkActivityPublisher: TestablePublisher<Bool, Never> = testScheduler.createRelativeTestablePublisher([
            // no events
        ])

        let viewModel = ViewModel(
            validURL: validURLPublisher.eraseToAnyPublisher(),
            isPerformingNetworkActivity: isPerformingNetworkActivityPublisher.eraseToAnyPublisher())

        let result = testScheduler.start { viewModel.$status }

        XCTAssertEqual(result.recordedOutput, [
            (200, .subscription),
            (200, .input(.initial)),
            (444, .input(.valid))
        ])
    }

    func testStatus_WithURL_PerformingNetworkActivity_ProducesPendingStatus() throws {
        let testScheduler = TestScheduler(initialClock: 0)
        let validURLPublisher: TestablePublisher<URL?, Never> = testScheduler.createRelativeTestablePublisher([
            (333, .input(irrelevantURL))
        ])
        let isPerformingNetworkActivityPublisher: TestablePublisher<Bool, Never> = testScheduler.createRelativeTestablePublisher([
            (400, .input(true))
        ])

        let viewModel = ViewModel(
            validURL: validURLPublisher.eraseToAnyPublisher(),
            isPerformingNetworkActivity: isPerformingNetworkActivityPublisher.eraseToAnyPublisher())

        let result = testScheduler.start { viewModel.$status }

        XCTAssertEqual(result.recordedOutput, [
            (200, .subscription),
            (200, .input(.initial)),
            (333, .input(.valid)),
            (400, .input(.pending))
        ])
    }

    func testStatus_WithURL_NoNetworkActivity_KeepsValidStatus() throws {
        let testScheduler = TestScheduler(initialClock: 0)
        let validURLPublisher: TestablePublisher<URL?, Never> = testScheduler.createRelativeTestablePublisher([
            (300, .input(irrelevantURL))
        ])
        let isPerformingNetworkActivityPublisher: TestablePublisher<Bool, Never> = testScheduler.createRelativeTestablePublisher([
            (500, .input(false))
        ])

        let viewModel = ViewModel(
            validURL: validURLPublisher.eraseToAnyPublisher(),
            isPerformingNetworkActivity: isPerformingNetworkActivityPublisher.eraseToAnyPublisher())

        let result = testScheduler.start { viewModel.$status }

        XCTAssertEqual(result.recordedOutput, [
            (200, .subscription),
            (200, .input(.initial)),
            (300, .input(.valid))
        ])
    }

    func testStatus_WithoutURL_PerformingNetworkActivity_ProducesPendingStatus() throws {
        let testScheduler = TestScheduler(initialClock: 0)
        let validURLPublisher: TestablePublisher<URL?, Never> = testScheduler.createRelativeTestablePublisher([
            (300, .input(nil))
        ])
        let isPerformingNetworkActivityPublisher: TestablePublisher<Bool, Never> = testScheduler.createRelativeTestablePublisher([
            (400, .input(true))
        ])

        let viewModel = ViewModel(
            validURL: validURLPublisher.eraseToAnyPublisher(),
            isPerformingNetworkActivity: isPerformingNetworkActivityPublisher.eraseToAnyPublisher())

        let result = testScheduler.start { viewModel.$status }

        XCTAssertEqual(result.recordedOutput, [
            (200, .subscription),
            (200, .input(.initial)),
            (300, .input(.invalid)),
            (400, .input(.pending))
        ])
    }

    func testStatus_WithoutURL_NoNetworkActivity_ProducesInvalidStatus() throws {
        let testScheduler = TestScheduler(initialClock: 0)
        let validURLPublisher: TestablePublisher<URL?, Never> = testScheduler.createRelativeTestablePublisher([
            (300, .input(nil))
        ])
        let isPerformingNetworkActivityPublisher: TestablePublisher<Bool, Never> = testScheduler.createRelativeTestablePublisher([
            (500, .input(false))
        ])

        let viewModel = ViewModel(
            validURL: validURLPublisher.eraseToAnyPublisher(),
            isPerformingNetworkActivity: isPerformingNetworkActivityPublisher.eraseToAnyPublisher())

        let result = testScheduler.start { viewModel.$status }

        XCTAssertEqual(result.recordedOutput, [
            (200, .subscription),
            (200, .input(.initial)),
            (300, .input(.invalid))
        ])
    }
}
