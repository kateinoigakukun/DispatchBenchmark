struct Column {
    let title: String
    let rows: [Row]

    func width() -> Int {
        return max(title.count, rows.map { $0.value.count }.max() ?? 0)
    }
}

struct Row {
    let value: String
}

struct Header {
    let value: String
}

struct Table {
    let header: Header
    let columns: [Column]
    init(header: Header, columns: [Column]) {
        self.header = header
        self.columns = columns
    }

    func render() -> String {
        let separator = columns.map { repeatElement("-", count: $0.width() + 2).joined() }.edged(separator: "+")
        let topHeader = "|" + header.value.centeredPadding(width: separator.count - 2) + "|"
        let columnHeaders = columns.map { " \($0.title.addingPadding(width: $0.width())) " }.edged(separator: "|")

        assert(columns.map { $0.rows.count }.allEqual())
        assert(columns.first != nil)

        let values = (0..<columns.first!.rows.count)
            .map { rowIndex in
                columns.map { " \($0.rows[rowIndex].value.addingPadding(width: $0.width())) " }.edged(separator: "|")
            }
            .joined(separator: "\n")
        return [separator, topHeader, separator, columnHeaders, separator, values, separator].joined(separator: "\n")
    }
}

extension String {
    fileprivate func addingPadding(width: Int) -> String {
        return self + repeatElement(" ", count: width-count)
    }

    fileprivate func centeredPadding(width: Int) -> String {
        let paddings = (width-self.count)
        let left = (paddings/2)
        let right = left + paddings % 2
        return String(repeatElement(" ", count: left)) + self + repeatElement(" ", count: right)
    }
}

extension Array where Element == String {
    fileprivate func edged(separator: String) -> String {
        return separator + self.joined(separator: separator) + separator
    }
}

extension Array where Element: Equatable {
    fileprivate func allEqual() -> Bool {
        if let firstElem = first {
            return !dropFirst().contains { $0 != firstElem }
        }
        return true
    }
}
