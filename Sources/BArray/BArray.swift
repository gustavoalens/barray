import Foundation

public class BArray<BData: BArrayData> {
    private(set) var storedData: [BData]
    
    public init(initialValues: [BData]) {
        storedData = initialValues
    }
    
    public init (unsorted values: [BData]) {
        storedData = values.sorted(by: { first, last in
            return first.id < last.id
        })
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
    
    public func insert(_ newItem: BData) {
        let (index, updateItem) = getNextIndex(byReference: newItem.id)
        guard !updateItem else {
            storedData[index] = newItem
            return
        }
        storedData.insertOrAppend(newItem, at: index)
    }
    
    public func insert(contentsOf items: [BData]) {
        items.forEach { insert($0) }
    }
    
    @discardableResult
    public func remove(byID id: BData.Comp) -> BData? {
        guard let index = getIndex(byID: id) else { return nil }
        return storedData.remove(at: index)
    }
    
    @discardableResult
    public func remove(item: BData) -> BData? { remove(byID: item.id) }
    
    public func contains(item: BData) -> Bool { return getIndex(byID: item.id) != nil }
    
    public func contains(where handler: (BData) -> Bool) -> Bool {
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
