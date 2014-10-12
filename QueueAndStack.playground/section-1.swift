// Homework - Implement a Queue (FIFO) and a Stack (LIFO)

class Queue {
    
    var intArray = [Int]()
    
    func enqueue(integers: Int...) {
        for integer in integers {
            self.intArray.append(integer)
        }
    }
    
    func dequeue() -> Int? {
        if !self.intArray.isEmpty {
            return self.intArray.removeAtIndex(0)
        } else {
            return nil
        }
    }
}

var queue = Queue()
queue.enqueue(1,2,3,4,5)

// Queues are FIFO, so console output will be 1,2,3,4,5
println("Queues are FIFO")
while queue.intArray.count > 0 {
    let dequeued = queue.dequeue()
    println("\(dequeued!)")
}

println("")

class Stack {
    
    var intArray = [Int]()
    
    func push(integers: Int...) {
        for integer in integers {
            self.intArray.append(integer)
        }
    }
    
    func pop() -> Int? {
        if !self.intArray.isEmpty {
            return self.intArray.removeLast()
        } else {
            return nil
        }
    }
}

var stack = Stack()
stack.push(1,2,3,4,5)

// Stacks are LIFO, so console output will be 5,4,3,2,1
println("Stacks are LIFO")
while stack.intArray.count > 0 {
    let popped = stack.pop()
    println("\(popped!)")
}

