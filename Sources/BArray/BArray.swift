import Foundation

public class BArray<BData: BArrayData> {
    private(set) var storedData: [BData]
    
    public init(initialValues: [BData]) {
        storedData = initialValues
    }
    
    public subscript(id: BData.Comp) -> BData? {
        get { getItem(byID: id) }
        
        set {
            guard let newValue: BData = newValue else { return }
            guard let index: Int = getIndex(byID: id) else {
                insert(newValue)
                return
            }
            storedData[index] = newValue
        }
    }
    
    func insert(_ newItem: BData) {
        let (index, updateItem) = getNextIndex(byReference: newItem.id)
        guard !updateItem else {
            storedData[index] = newItem
            return
        }
        storedData.insertOrAppend(newItem, at: index)
    }
    
    func insert(contentsOf items: [BData]) {
        items.forEach { insert($0) }
    }
    
    @discardableResult
    func remove(byID id: BData.Comp) -> BData? {
        guard let index = getIndex(byID: id) else { return nil }
        return storedData.remove(at: index)
    }
    
    @discardableResult
    func remove(item: BData) -> BData? { remove(byID: item.id) }
    
    func contains(item: BData) -> Bool { return getIndex(byID: item.id) != nil }
    
    func contains(where handler: (BData) -> Bool) -> Bool {
        return storedData.contains(where: handler)
    }
    
    private func getIndex(byID id: BData.Comp) -> Int? {
        var lower = 0
        var upper = storedData.count - 1
        while lower <= upper {
            let mid: Int = (upper + lower) / 2
            let actual: BData = storedData[mid]
            
            if actual.id == id { return mid }
            if storedData[lower].id == id { return lower }
            if storedData[upper].id == id { return upper }
            if actual.id > id {
                lower += 1
                upper = mid - 1
            } else {
                lower = mid + 1
                upper -= 1
            }
        }
        return nil
    }
    
    private func getItem(byID id: BData.Comp) -> BData? {
        guard let index: Int = getIndex(byID: id) else {
            return nil
        }
        return storedData[index]
    }
    
    private func getNextIndex(byReference id: BData.Comp) -> (Int, Bool) {
        var lower = 0
        var upper = storedData.count - 1
        var mid: Int = (upper + lower) / 2
        while lower <= upper {
            mid = (upper + lower) / 2
            let actual: BData = storedData[mid]
            
            if actual.id == id { return (mid, true) }
            if storedData[lower].id > id { return (lower, false) }
            if storedData[upper].id < id { return (upper + 1, false) }
            if actual.id > id {
                lower += 1
                upper = mid - 1
            } else {
                lower = mid + 1
                upper -= 1
            }
        }
        return (storedData[mid].id < id ? mid + 1 : mid, false)
    }
}

public protocol BArrayData {
    associatedtype Comp: Comparable
    var id: Comp { get }
}

extension Array {
    public mutating func insertOrAppend(_ newItem: Element, at i: Int) {
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
