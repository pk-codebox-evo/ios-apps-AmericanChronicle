struct SearchParameters {
    let term: String
    let states: [String]
    let earliestDayMonthYear: DayMonthYear
    let latestDayMonthYear: DayMonthYear
}

extension SearchParameters: Hashable {
    var hashValue: Int {
        return "\(term)-\(states)-earliestDate-latestDate".hashValue
    }
}

extension SearchParameters: Equatable {}

func == (lhs: SearchParameters, rhs: SearchParameters) -> Bool {
    return (lhs.term == rhs.term)
        && (lhs.states == rhs.states)
        && (lhs.earliestDayMonthYear == rhs.earliestDayMonthYear)
        && (lhs.latestDayMonthYear == rhs.latestDayMonthYear)
}
