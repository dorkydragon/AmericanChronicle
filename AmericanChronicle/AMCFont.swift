struct AMCFont {
    fileprivate static let bodyFontName = "AvenirNext-Regular"
    fileprivate static let bodyBoldFontName = "AvenirNext-Medium"
    fileprivate static let largeFontSize = CGFloat(20.0)
    fileprivate static let mediumFontSize = CGFloat(16.0)
    fileprivate static let smallFontSize = CGFloat(14.0)
    fileprivate static let verySmallFontSize = CGFloat(12.0)

    static let largeRegular = UIFont(name: bodyFontName, size: largeFontSize)
    static let largeBold = UIFont(name: bodyBoldFontName, size: largeFontSize)
    static let mediumRegular = UIFont(name: bodyFontName, size: mediumFontSize)
    static let mediumBold = UIFont(name: bodyBoldFontName, size: mediumFontSize)
    static let smallRegular = UIFont(name: bodyFontName, size: smallFontSize)
    static let smallBold = UIFont(name: bodyBoldFontName, size: smallFontSize)
    static let verySmallRegular = UIFont(name: bodyFontName, size: verySmallFontSize)
    static let verySmallBold = UIFont(name: bodyBoldFontName, size: verySmallFontSize)
}
