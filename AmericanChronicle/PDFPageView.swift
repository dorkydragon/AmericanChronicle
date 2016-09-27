final class PDFPageView: UIView {

    // mark: Properties

    var pdfPage: CGPDFPage? {
        didSet { layer.setNeedsDisplay() }
    }
    var highlights: OCRCoordinates? {
        didSet { layer.setNeedsDisplay() }
    }

    // mark: Init methods

    func commonInit() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        autoresizingMask = UIViewAutoresizing()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    // mark: UIView overrides

    override func draw(_ layer: CALayer, in ctx: CGContext) {

        // Draw a blank white background (in case pdfPage is empty).
        ctx.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ctx.fill(bounds)

        pdfPage?.drawInContext(ctx, boundingRect: bounds, withHighlights: highlights)
    }
}
