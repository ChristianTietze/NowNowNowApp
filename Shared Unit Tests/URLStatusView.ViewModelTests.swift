//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import NowNowNow

class URLStatusView_ViewModel: XCTestCase {
    typealias Status = URLStatusView.ViewModel.Status

    var irrelevantURL: URL { URL(fileURLWithPath: "/tmp") }

    func testConvenienceInitFromURLAndPending() throws {
        // Note: we cannot get back to `.initial` by design.
        XCTAssertEqual(Status(url: nil, isPending: false), .invalid)
        XCTAssertEqual(Status(url: nil, isPending: true), .pending)
        XCTAssertEqual(Status(url: irrelevantURL, isPending: false), .valid)
        XCTAssertEqual(Status(url: irrelevantURL, isPending: true), .pending)
    }
}
