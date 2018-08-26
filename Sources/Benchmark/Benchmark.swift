
final class FinalClass {
    @inline(never)
    func foo() {}
}

class NonFinalClass {
    @inline(never)
    func bar() {}
}

class SubClass: NonFinalClass {
    override func bar() {}
}

protocol Protocol {
    func baz()
}

class ConformingClass: Protocol {
    @inline(never)
    func baz() {}
}


// Benchmark
import Foundation

struct Measure {
    private let block: () -> ()

    init<T>(instance: T, block: @escaping (T) -> ()) {
        self.block = {
            block(instance)
        }
    }

    func execute() -> clock_t {
        let start = clock()
        block()
        return clock() - start
    }
}

func callStatic(_ instance: FinalClass, repeatCount: Int) {
    for _ in 0..<repeatCount {
        instance.foo()
    }
}

func callVTable(_ instance: NonFinalClass, repeatCount: Int) {
    for _ in 0..<repeatCount {
        instance.bar()
    }
}

func callWitness<T: Protocol>(_ instance: T, repeatCount: Int) {
    for _ in 0..<repeatCount {
        instance.baz()
    }
}
