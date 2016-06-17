extension CGPDFPageRef {
    var mediaBoxRect: CGRect {
        return CGPDFPageGetBoxRect(self, .MediaBox)
    }

    func drawInContext(ctx: CGContextRef,
                       boundingRect: CGRect,
                       withHighlights highlights: OCRCoordinates?) {

        CGContextSaveGState(ctx)

        // Flip the context so that the PDF page is rendered right side up.
        CGContextTranslateCTM(ctx, 0.0, boundingRect.size.height)
        CGContextScaleCTM(ctx, 1.0, -1.0)

        // Scale the context so that the PDF page is drawn to fill the view exactly.
        let pdfSize = CGPDFPageGetBoxRect(self, .MediaBox).size
        let widthScale = boundingRect.size.width/pdfSize.width
        let heightScale = boundingRect.size.height/pdfSize.height
        let smallerScale = fmin(widthScale, heightScale)
        CGContextScaleCTM(ctx, smallerScale, smallerScale)

        let scaledPDFWidth = (pdfSize.width * smallerScale)
        let scaledPDFHeight = (pdfSize.height * smallerScale)
        let xTranslate = (boundingRect.size.width - scaledPDFWidth) / 2.0
        let yTranslate = (boundingRect.size.height - scaledPDFHeight) / 2.0
        CGContextTranslateCTM(ctx, xTranslate, yTranslate)

        CGContextDrawPDFPage(ctx, self)

        CGContextRestoreGState(ctx)

        // --- Draw highlights (if they exist) --- //

        if let highlightsWidth = highlights?.width, highlightsHeight = highlights?.height {
            CGContextSaveGState(ctx)
            let widthScale = scaledPDFWidth/highlightsWidth
            let heightScale = scaledPDFHeight/highlightsHeight
            CGContextScaleCTM(ctx, widthScale, heightScale)

            let scaledHighlightsWidth = (highlightsWidth * widthScale)
            let scaledHighlightsHeight = (highlightsHeight * heightScale)
            let xTranslate = (boundingRect.size.width - scaledHighlightsWidth) / 2.0
            let yTranslate = (boundingRect.size.height - scaledHighlightsHeight) / 2.0
            CGContextTranslateCTM(ctx, xTranslate, yTranslate)

            CGContextSetRGBFillColor(ctx, 0, 1.0, 0, 0.4)

            for (_, rects) in highlights?.wordCoordinates ?? [:] {
                for rect in rects {
                    CGContextFillRect(ctx, rect)
                }
            }
            CGContextRestoreGState(ctx)
        }
    }
}
