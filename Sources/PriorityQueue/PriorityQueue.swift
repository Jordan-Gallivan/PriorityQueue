//
//  PriorityQueue.swift
//
//  Created by Jordan Gallivan on 9/27/23.
//

import Foundation

/// A queue data structure that maintains a maximum heap property.
///
/// You can use a priority queue instead of a queue when the maximum element in the queue 
/// must be accessible in O(1) time without modifying the queue, or O(log *n*) time by removing
/// the maximum element.
///
/// You can  create a priority queue with any element type that conforms to the `Comparable`
/// protocol and that elements comparison method will be used if no comparison function is passed
/// through the trailing closure.  If a comparison function is passed as through the trailing closure, the
/// element's existing comparison method will be ignored, and the heapy property will be maintained
/// through the use of the passed comparison function.
///
/// You can also create a priority queue with any element type provided a comparison function is passed
/// through the trailing closure.
///
/// Accessing Priority Queue Values
/// =======================
///  - Use the `isEmpty` property to check quickly whether the priority queue has any elements,
///  or use the `count` property to find the number of elements in the priority queue.
///
/// Priority Queue Operations
/// =======================
/// - Use the `add(_:)` method to add an element to the priority queue.
/// - Use the `peek()` method to view the maximum element in the priority queue
/// without modifying the queue.
/// - Use the `poll()` method to view and remove the maximum element in the
/// priority queue.
struct PriorityQueue<Element> {
    
    private var heap = [Element]()
    private let comparator: (Element, Element) -> Bool
    /// The number of elements in the Priority Queue.
    var count: Int { heap.count }
    /// A Boolean value indicating whether the collection is empty.
    var isEmpty: Bool { heap.count == 0 }
    
    /// Creates a new, empty Priority Queue to be sorted using the given predicate 
    /// as the comparison between elements.
    ///
    ///     enum Status {
    ///         case success
    ///         case failure(Int)
    ///     }
    ///
    ///     var queue: PriorityQueue<Status> = PriorityQueue {
    ///         switch ($0, $1) {
    ///         case let (.failure(aAttempts), .failure(bAttempts)):
    ///             return aAttempts < bAttempts
    ///         case (.success, .success):
    ///             return false
    ///         case (.success, .failure(_)):
    ///             return true
    ///         case (.failure(_), .success):
    ///             return false
    ///         }
    ///     }
    ///
    ///     print(queue.isEmpty)
    ///     // Prints "true"
    ///
    /// - Complexity: O(1)
    /// - Parameters:
    ///   - collection: Collection to be placed in the Priority Queue.
    ///   - areInIncreasingOrder: A predicate that returns true if the first argument should be 
    ///   ordered before its second argument; otherwise, false.
    init(by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        self.comparator = areInIncreasingOrder
    }
    
    /// Creates a new Priority Queue containing the elements of a collection, to be sorted using the given
    /// predicate as the comparison between elements.
    ///
    ///     enum Status {
    ///        case success
    ///        case failure(Int)
    ///     }
    ///     
    ///     let collection: [Status] = [.failure(1), .success, .failure(2), .failure(3)]
    ///
    ///     var enumQueue = PriorityQueue(collection) {
    ///         switch ($0, $1) {
    ///         case let (.failure(aAttempts), .failure(bAttempts)):
    ///             return aAttempts < bAttempts
    ///         case (.success, .success):
    ///             return false
    ///         case (.success, .failure(_)):
    ///             return true
    ///         case (.failure(_), .success):
    ///             return false
    ///         }
    ///     }
    ///
    ///     if let maxElement = queue.poll() {
    ///         print(maxElement)
    ///     }
    ///     // Prints "success"
    ///
    ///     if let nextMaxElement = queue.poll() {
    ///         print(nextMaxElement)
    ///     }
    ///     // Prints "failure(1)"
    ///
    /// - Complexity: O(*n* log *n*) where *n* is the length of the collection.
    /// - Parameters:
    ///   - collection: Collection to be placed in the Priority Queue.
    ///   - areInIncreasingOrder: A predicate that returns true if the first argument 
    ///   should be ordered before its second argument; otherwise, false.
    init(_ collection: [Element], by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        self.comparator = areInIncreasingOrder
        self.heap = collection
        for i in (0...(count/2 - 1)).reversed() {
            heapify(i)
        }
    }
    
    /// Adds a new element to the Priority Queue.
    ///
    ///     var queue = PriorityQueue([10, 20, 30, 40, 50])
    ///     queue.add(60)
    ///     if let maxElement = queue.peek() {
    ///         print(maxElement)
    ///     }
    ///     // Prints "60"
    ///
    /// - Complexity: O(log *n*) where *n* is the length of the priority queue.
    /// - Parameters:
    ///    - newElement: The element to be added to the Priority Queue.
    mutating func add(_ newElement: Element) {
        heap.append(newElement)
        var child = heap.count - 1
        var parent = (child - 1) / 2
        
        // percolate up
        while (parent >= 0 && comparator(heap[child], heap[parent])) {
            heap.swapAt(parent, child)
            child = parent
            parent = Int((child - 1) / 2)
        }
    }
    
    /// The maximum element in the Priority Queue.
    ///
    ///     var queue = PriorityQueue([10, 20, 30, 40, 50])
    ///     if let maxElement = queue.peek() {
    ///         print(maxElement)
    ///     }
    ///     // Prints "50"
    ///
    /// - Complexity: O(1)
    /// - Returns: The maximum element in the Priority Queue if the Priority Queue is not empty; otherwise, nil.
    func peek() -> Element? {
        guard !isEmpty else { return nil }
        
        return heap[0]
    }
    
    /// Returns and Removes the maximum element in the Priority Queue.
    ///
    ///     var queue = PriorityQueue([10, 20, 30, 40, 50])
    ///     if let maxElement = queue.poll() {
    ///         print(maxElement)
    ///     }
    ///     // Prints "50"
    ///     if let nextMaxElement = queue.poll() {
    ///         print(nextMaxElement)
    ///     }
    ///     // Prints "40"
    ///
    /// - Complexity: O(log *n*) where *n* is the length of the priority queue.
    /// - Returns: The maximum element in the Priority Queue if the Priority Queue is not empty; otherwise, nil.
    mutating func poll() -> Element? {
        guard !isEmpty else { return nil }
        
        let returnValue = heap[0]
        heap.swapAt(0, count - 1)
        heap.removeLast()
        
        heapify(0)
        
        return returnValue
    }
    
    
    /// Percolates the element at position parent in the Heap down.
    /// - Parameters:
    ///    - parent: Index of the element to be percolated down.
    private mutating func heapify(_ parent: Int) {
        var parent = parent // function parameters are immutable
        var leftChild, rightChild, minChild: Int
        
        while true {
            leftChild = 2 * parent + 1
            // verify heap size not exceeded
            if leftChild >= count {
                break
            }
            
            rightChild = leftChild + 1
            
            // assume minChild is left, verify
            minChild = leftChild
            if rightChild < count && comparator(heap[rightChild], heap[leftChild]) {
                minChild = rightChild
            }
            
            // validate heap property parent < children
            if !comparator(heap[parent], heap[minChild]) {
                heap.swapAt(parent, minChild)
                parent = minChild
            } else {
                break
            }
        }
    }
}

extension PriorityQueue where Element: Comparable {
    
    /// Creates a new, empty Priority Queue.
    ///
    /// This is equivalent to initializing an empty array literal.  For example:
    ///
    ///     var queue = PriorityQueue<Int>()
    ///     print(queue.isEmpty)
    ///     // Prints "true"
    ///
    /// - Complexity: O(1)
    init() {
        self.init() { $0 > $1 }
    }
    
    /// Creates a new Priority Queue containing the elements of a collection.
    ///
    ///     var queue = PriorityQueue([10, 20, 30, 40, 50])
    ///     if let maxElement = queue.peek() {
    ///         print(maxElement)
    ///     }
    ///     // Prints "50"
    ///
    /// - Complexity: O(*n* log *n*) where *n* is the length of the collection.
    /// - Parameters:
    ///   - collection: Collection to be placed in the Priority Queue.
    init(_ collection: [Element]) {
        self.init(collection) { $0 > $1 }
    }
}
