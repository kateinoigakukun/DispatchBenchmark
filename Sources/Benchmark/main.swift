import Foundation

let repeatCounts = (4..<8).map { (0..<$0).reduce(10) { n, _ in n * 10 } }

func measures(for repeatCount: Int) -> [Measure] {
    return [
        Measure(instance: FinalClass()) { instance in
            callStatic(instance, repeatCount: repeatCount)
        },
        Measure(instance: NonFinalClass()) { instance in
            callVTable(instance, repeatCount: repeatCount)
        },
        Measure(instance: ConformingClass()) { instance in
            callWitness(instance, repeatCount: repeatCount)
        }
    ]
}

let columns = repeatCounts.map { n -> Column in
    let rows = measures(for: n).map { measure -> Row in
        defer { sleep(1) }
        return Row(value: measure.execute().description)
    }
    return Column(title: "\(n) (times)", rows: rows)
}

let kindColumn = Column(
    title: "Kind",
    rows: [
        Row(value: "static"),
        Row(value: "vtable"),
        Row(value: "witness")
    ]
)

let table = Table(
    header: Header(value: "Performance (CPU time)"),
    columns: [kindColumn] + columns
)

print(table.render())
