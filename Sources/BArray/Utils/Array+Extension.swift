extension Array {
    mutating func insertOrAppend(_ newItem: Element, at i: Int) {
        guard i < count else {
            append(newItem)
            return
        }
        guard i >= 0 else {
            insert(newItem, at: 0)
            return
        }
        insert(newItem, at: i)
    }
}

extension Array where Element: Comparable {
    func isSorted(isOrderedBefore: (Element, Element) -> Bool = { $0 < $1 }) -> Bool {
        for i in 1..<self.count {
            if !isOrderedBefore(self[i-1], self[i]) {
                return false
            }
        }
        return true
    }
}
