import XCTest
@testable import PriorityQueue

final class PriorityQueueTests: XCTestCase {
    
    func testEmptyNonComparable() throws {
        enum Status {
            case success
            case failure(Int)
        }
        
        let queue: PriorityQueue<Status> = PriorityQueue {
            switch ($0, $1) {
            case let (.failure(aAttempts), .failure(bAttempts)):
                return aAttempts < bAttempts
            case (.success, .success):
                return false
            case (.success, .failure(_)):
                return true
            case (.failure(_), .success):
                return false
            }
        }
        
        XCTAssertTrue(queue.isEmpty)
    }
    
    func testNonEmptyNonComparable() throws {
        enum Status: Equatable {
            case success
            case failure(Int)
        }
        
        let collection: [Status] = [.failure(1), .success, .failure(2), .failure(3)]
        
        var enumQueue = PriorityQueue(collection) {
            switch ($0, $1) {
            case let (.failure(aAttempts), .failure(bAttempts)):
                return aAttempts < bAttempts
            case (.success, .success):
                return false
            case (.success, .failure(_)):
                return true
            case (.failure(_), .success):
                return false
            }
        }
        
        XCTAssertEqual(enumQueue.poll(), .success)
        XCTAssertEqual(enumQueue.poll(), .failure(1))
    }
    
    func testEmptyComparable() throws {
        let queue: PriorityQueue<Int> = PriorityQueue()
        
        XCTAssertTrue(queue.isEmpty)
    }
    
    func testNonEmptyComparable() throws {
        let intQueue = PriorityQueue([10, 20, 30, 40, 50])
        
        XCTAssertEqual(intQueue.peek(), 50)
    }
    
    func testNonEmptyComparableWithComparisonFunc() throws {
        let minQueue = PriorityQueue([10, 20, 30, 40, 50]) { $1 > $0 }
        
        XCTAssertEqual(minQueue.peek(), 10)
    }
    
    /// Verify isEmpty for non-empty and empty queues.
    func testIsEmpty() throws {
        let emptyQueue: PriorityQueue<Int> = PriorityQueue()
        let nonEmptyQueue = PriorityQueue([10, 20, 30, 40, 50])
        
        XCTAssertTrue(emptyQueue.isEmpty)
        XCTAssertFalse(nonEmptyQueue.isEmpty)
    }
    
    /// Verify count for non-empty and empty queues.
    func testCount() throws {
        let emptyQueue: PriorityQueue<Int> = PriorityQueue()
        let nonEmptyQueue = PriorityQueue([10, 20, 30, 40, 50])
        
        XCTAssertEqual(emptyQueue.count, 0)
        XCTAssertEqual(nonEmptyQueue.count, 5)
    }
    
    /// Verify all elements removed in non-icnreasing order from the queue
    func testHeapProperty() throws {
        var intQueue = PriorityQueue([10, 20, 30, 40, 50])
        
        XCTAssertEqual(intQueue.poll(), 50)
        XCTAssertEqual(intQueue.poll(), 40)
        XCTAssertEqual(intQueue.poll(), 30)
        XCTAssertEqual(intQueue.poll(), 20)
        XCTAssertEqual(intQueue.poll(), 10)
    }
    
    /// Verify an element is added to the queue, the count increases. Verify if a new maximum element is added,
    /// the new element is returned on a peek() call.  Verify repeated elements are successfully added.
    func testAddComparable() throws {
        var intQueue = PriorityQueue([10, 20, 30, 40, 50])
        XCTAssertEqual(intQueue.count, 5)
        // new maximum
        intQueue.add(60)
        XCTAssertEqual(intQueue.count, 6)
        XCTAssertEqual(intQueue.peek(), 60)
        
        // repeated element
        intQueue.add(10)
        XCTAssertEqual(intQueue.count, 7)
    }
    
    /// Verify a queue with a user defined comparison funciton passed through a trailing closure, can be added to
    func testAddComparableWithComparisonFunc() throws {
        var intQueue = PriorityQueue([10, 20, 30, 40, 50]) { $0 < $1 }
        XCTAssertEqual(intQueue.count, 5)
        // new maximum
        intQueue.add(0)
        XCTAssertEqual(intQueue.count, 6)
        XCTAssertEqual(intQueue.peek(), 0)
        
        // repeated element
        intQueue.add(10)
        XCTAssertEqual(intQueue.count, 7)
    }
    
    /// Verfiy a queue with created with non-Comparable elements can be added to
    func testAddNonComparable() throws {
        enum Status: Equatable {
            case success
            case failure(Int)
        }
        
        let collection: [Status] = [.failure(1), .failure(2), .failure(3)]
        
        var enumQueue = PriorityQueue(collection) {
            switch ($0, $1) {
            case let (.failure(aAttempts), .failure(bAttempts)):
                return aAttempts < bAttempts
            case (.success, .success):
                return false
            case (.success, .failure(_)):
                return true
            case (.failure(_), .success):
                return false
            }
        }
        
        XCTAssertEqual(enumQueue.count, 3)
        enumQueue.add(.success)
        XCTAssertEqual(enumQueue.peek(), .success)
    }
    
    /// Verify peek() does not change the number of elements in the queue.
    func testPeek() throws {
        let intQueue = PriorityQueue([10, 20, 30, 40, 50])
        XCTAssertEqual(intQueue.count, 5)
        XCTAssertEqual(intQueue.peek(), 50)
        XCTAssertEqual(intQueue.count, 5)
    }
    
    /// Verify peek() returns nil when called on empty queue.
    func testPeekNilForEmptyQueue() throws {
        let emptyQueue: PriorityQueue<Int> = PriorityQueue()
        XCTAssertNil(emptyQueue.peek())
    }
    
    /// Verify poll() returns the maximum element and the element is removed form the queue.
    /// Verify if multiple of the same maixmum element, only one is removed
    func testPoll() throws {
        var intQueue = PriorityQueue([10, 20, 30, 40, 50, 50])
        XCTAssertEqual(intQueue.count, 6)
        XCTAssertEqual(intQueue.poll(), 50)
        XCTAssertEqual(intQueue.count, 5)
        XCTAssertEqual(intQueue.poll(), 50)
    }
    
    /// Verify poll() returns nil when called on empty queue.
    func testPollNilForEmptyQueue() {
        var emptyQueue: PriorityQueue<Int> = PriorityQueue()
        XCTAssertNil(emptyQueue.poll())
    }
}
