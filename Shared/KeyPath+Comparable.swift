//  Copyright © 2021 Christian Tietze. All rights reserved. Distributed under the MIT License.

enum SortOrder<V: Comparable> {
    case ascending, descending

    fileprivate var comparator: (_ lhs: V, _ rhs: V) -> Bool {
        switch self {
        case .ascending:
            return { $0 < $1 }
        case .descending:
            return { $0 > $1 }
        }
    }
}

extension Collection {
    func sorted<V: Comparable>(by keyPath: KeyPath<Element, V>, order: SortOrder<V>) -> [Element] {
        return sorted(by: { order.comparator($0[keyPath: keyPath], $1[keyPath: keyPath]) })
    }
}
