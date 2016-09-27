extension CGPDFPage {
    var mediaBoxRect: CGRect {
        return self.getBoxRect(.mediaBox)
    }

    func drawInContext(_ ctx: CGContext,
                       boundingRect: CGRect,
                       withHighlights highlights: OCRCoordinates?) {

        ctx.saveGState()

        // Flip the context so that the PDF page is rendered right side up.
        ctx.translateBy(x: 0.0, y: boundingRect.size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)

        // Scale the context so that the PDF page is drawn to fill the view exactly.
        let pdfSize = self.getBoxRect(.mediaBox).size
        let widthScale = boundingRect.size.width/pdfSize.width
        let heightScale = boundingRect.size.height/pdfSize.height
        let smallerScale = fmin(widthScale, heightScale)
        ctx.scaleBy(x: smallerScale, y: smallerScale)

        let scaledPDFWidth = (pdfSize.width * smallerScale)
        let scaledPDFHeight = (pdfSize.height * smallerScale)
        let xTranslate = (boundingRect.size.width - scaledPDFWidth) / 2.0
        let yTranslate = (boundingRect.size.height - scaledPDFHeight) / 2.0
        ctx.translateBy(x: xTranslate, y: yTranslate)

        ctx.drawPDFPage(self)

        ctx.restoreGState()

        // --- Draw highlights (if they exist) --- //

        if let highlightsWidth = highlights?.width, let highlightsHeight = highlights?.height {
            ctx.saveGState()
            let widthScale = scaledPDFWidth/highlightsWidth
            let heightScale = scaledPDFHeight/highlightsHeight
            ctx.scaleBy(x: widthScale, y: heightScale)

            let scaledHighlightsWidth = (highlightsWidth * widthScale)
            let scaledHighlightsHeight = (highlightsHeight * heightScale)
            let xTranslate = (boundingRect.size.width - scaledHighlightsWidth) / 2.0
            let yTranslate = (boundingRect.size.height - scaledHighlightsHeight) / 2.0
            ctx.translateBy(x: xTranslate, y: yTranslate)

            ctx.setFillColor(red: 0, green: 1.0, blue: 0, alpha: 0.4)

            for (_, rects) in highlights?.wordCoordinates ?? [:] {
                for rect in rects {
                    ctx.fill(rect)
                }
            }
            ctx.restoreGState()
        }
    }
}
