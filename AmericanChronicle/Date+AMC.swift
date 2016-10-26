extension Date {
    var year: Int {
        let calendar = Calendar.autoupdatingCurrent
        return (calendar as NSCalendar).component(NSCalendar.Unit.year, from: self)
    }

    var month: Int {
        let calendar = Calendar.autoupdatingCurrent
        return (calendar as NSCalendar).component(NSCalendar.Unit.month, from: self)
    }
}
