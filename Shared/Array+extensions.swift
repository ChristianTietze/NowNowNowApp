//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

extension Array {
    func removingAll(where predicate: (Element) throws -> Bool) rethrows -> [Element] {
        var result = self
        try result.removeAll(where: predicate)
        return result
    }

    func appending(_ element: Element) -> [Element] {
        var result = self
        result.append(element)
        return result
    }
}
