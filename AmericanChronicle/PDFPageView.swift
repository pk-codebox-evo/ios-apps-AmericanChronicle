//
//  PDFPageView.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/3/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

class PDFPageView: UIView {

    var pdfPage: CGPDFPageRef? {
        didSet {
            layer.setNeedsDisplay()
        }
    }

    var highlights: OCRCoordinates? {
        didSet {
            layer.setNeedsDisplay()
        }
    }

    func commonInit() {
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 1.0
        autoresizingMask = .None
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {

        // Draw a blank white background (in case pdfPage is empty).
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
        CGContextFillRect(ctx, bounds);

        pdfPage?.drawInContext(ctx, boundingRect: bounds, withHighlights: highlights)
    }
}

extension CGPDFPageRef {
    func drawInContext(ctx: CGContextRef, boundingRect: CGRect, withHighlights highlights: OCRCoordinates?) {

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
