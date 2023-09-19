import XCTest
@testable import BArray

class BArrayTests: XCTestCase {
    
    let batchSize = 1000000
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    
    func testSearchValue() throws {
        let data = getRandomBArray()
        data.refValues.enumerated().forEach { offset, value in
            XCTAssertEqual(value, data.bArray[value])
        }
    }
    
    func testInsert() throws {
        let data = getSequentialBArray(batchSize: 100, multiplier: 10)
        data.refValues.forEach { refValue in
            let valueToInsert = refValue + 5
            data.bArray.insert(valueToInsert)
            XCTAssertTrue(data.bArray.storedData.isSorted())
        }
        data.refValues.forEach { refValue in
            let valueToInsert = refValue - 2
            data.bArray.insert(valueToInsert)
            XCTAssertTrue(data.bArray.storedData.isSorted())
        }
    }
    
    func testRemove() throws {
        var data = getRandomBArray(batchSize: 10000)
        data.refValues.remove(at: 0)
        var range = 0..<data.refValues.count
        while !range.isEmpty {
            let index = Int.random(in: range)
            let valueToRemove = data.refValues.remove(at: index)
            data.bArray.remove(item: valueToRemove)
            XCTAssertTrue(!data.bArray.storedData.contains(valueToRemove) && data.bArray.storedData.isSorted())
            range = 0..<data.refValues.count
        }

    }
    
    func testSearchPerformance() throws {
        let (data, refValues) = getPerfomanceData()
        self.measure {
            for refValue in refValues {
                _ = data.bArray[refValue]
            }
        }
    }
    
    func testPerfomanceComparable() throws {
        let (data, refValues) = getPerfomanceData()
        self.measure {
            for refValue in refValues {
                for value in data.refValues {
                    if value == refValue {
                        return
                    }
                }
            }
        }
    }
    
    private func getRandomBArray(batchSize size: Int? = nil) -> (refValues: [Int], bArray: BArray<Int>) {
        var setValues: Set<Int> = Set()
        while setValues.count < size ?? batchSize {
            setValues.insert(Int.random(in: 0...Int.max))
        }
        let initialValues = setValues.sorted()
        return (initialValues, BArray(initialValues: initialValues))
    }
    
    private func getSequentialBArray(batchSize size: Int? = nil, multiplier: Int = 1) -> (refValues: [Int], bArray: BArray<Int>) {
        let batchSize = size ?? batchSize
        var initialValues: [Int] = Array(1...batchSize)
        if multiplier > 1 {
            initialValues = initialValues.map { $0 * multiplier }
        }
        return (initialValues, BArray(initialValues: initialValues))
    }
    
    private func getPerfomanceData() -> (data: (refValues: [Int], bArray: BArray<Int>), refValues: [Int]) {
        let batchSize = 10000000
        let data = getSequentialBArray(batchSize: batchSize)
        let refValues: [Int] = Array(repeating: [1000000, 12500000, 2000000, 5000000, 8000000, 9999999, 10000000], count: 1000).reduce([]) { partialResult, part in
            return partialResult + part
        }
        return (data, refValues)
    }
    
}

extension Int: BArrayData {
    public var id: Int { self }
}
