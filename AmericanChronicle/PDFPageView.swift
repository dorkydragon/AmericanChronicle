final class PDFPageView: UIView {

    // MARK: Properties

    var pdfPage: CGPDFPage? {
        didSet { layer.setNeedsDisplay() }
    }
    var highlights: OCRCoordinates? {
        didSet { layer.setNeedsDisplay() }
    }

    // MARK: Init methods

    func commonInit() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        autoresizingMask = .flexibleLeftMargin
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: UIView overrides

    override func draw(_ layer: CALayer, in ctx: CGContext) {

        // Draw a blank white background (in case pdfPage is empty).
        ctx.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ctx.fill(bounds)

        pdfPage?.drawInContext(ctx, boundingRect: bounds, withHighlights: highlights)
    }
}
