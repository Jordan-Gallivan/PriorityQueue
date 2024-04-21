# PriorityQueue

A queue data structure that maintains a maximum heap property.

You can use a priority queue instead of a queue when the maximum element in the queue 
must be accessible in O(1) time without modifying the queue, or O(log *n*) time by removing
the maximum element.

You can create a priority queue with any element type that conforms to the `Comparable`
protocol and that element's comparison method will be used if no comparison function is passed
through the trailing closure.  If a comparison function is passed as through the trailing closure, the
element's existing comparison method will be ignored, and the heap property will be maintained
through the use of the passed comparison function.

```
// create a maximum heap priority queue using the element's comparison function
var intQueue = PriorityQueue([10, 20, 30, 40, 50])
if let intQueueMax = intQueue.peek() {
  print(intQueueMax)
}
// Prints "50"

// create a minimum heap priority queue using a custom comparison function
var minQueue = PriorityQueue([10, 20, 30, 40, 50]) { $1 > $0 }
if let minQueueMin = minQueue.peek() {
  print(minQueueMin)
}
// Prints "10"
```

You can also create a priority queue with any element type provided a comparison function is passed
through the trailing closure.

```
enum Status {
  case success
  case failure(Int)
}

var enumQueue: PriorityQueue<Status> = PriorityQueue([.failure(1), .success, .failure(2), .failure(3)]) {
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

if let maxElement = enumQueue.poll() {
  print(maxElement)
}
// Prints "success"

if let nextMaxElement = enumQueue.poll() {
  print(nextMaxElement)
}
// Prints "failure(1)"
```

Accessing Priority Queue Values
=======================
- Use the `isEmpty` property to check quickly whether the priority queue has any elements,
or use the `count` property to find the number of elements in the priority queue.
```
if intQueue.isEmpty {
  print("The Queue is Empty")
} else {
  print("The Queue has \(intQueue.count) elements.")
}
// Prints "The Queue has 5 elements."
```

Priority Queue Operations
=======================
- Use the `add(_:)` method to add an element to the priority queue.
  ```
  intQueue.add(60)
  if let maxElement = intQueue.peek() {
    print(maxElement)
  }
  // Prints "60"
  ```
- Use the `peek()` method to view the maximum element in the priority queue
without modifying the queue.
```
print("The Queue has \(intQueue.count) elements")
if let currentMaxElement = intQueue.peek() {
    print(currentMaxElement)
}
print("The Queue has \(intQueue.count) elements")
// Prints "The Queue has 6 elements."
// Prints "60"
// Prints "The Queue has 6 elements."
```
- Use the `poll()` method to view and remove the maximum element in the
priority queue.
```
print("The Queue has \(intQueue.count) elements")
if let removedMaxElement = intQueue.poll() {
    print(removedMaxElement)
}
print("The Queue has \(intQueue.count) elements")
// Prints "The Queue has 6 elements."
// Prints "60"
// Prints "The Queue has 5 elements."
```

