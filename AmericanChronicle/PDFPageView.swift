//
//  PDFPageView.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/3/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

class PDFPageView: UIView {

    let loggingEnabled = false
    func p(string: String) {
        if loggingEnabled {
            print(string)
        }
    }

    var pdfPage: CGPDFPageRef? {
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

        // Draw a blank white background.
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
        CGContextFillRect(ctx, bounds);

        // Show an empty page if there is no pdf.
        if pdfPage == nil { return }

        CGContextSaveGState(ctx)

        // Flip the context so that the PDF page is rendered right side up.
        CGContextTranslateCTM(ctx, 0.0, bounds.size.height)
        CGContextScaleCTM(ctx, 1.0, -1.0)

        // Scale the context so that the PDF page is drawn to fill the view exactly.
        let pdfSize = CGPDFPageGetBoxRect(pdfPage, .MediaBox).size
        let widthScale = bounds.size.width/pdfSize.width
        let heightScale = bounds.size.height/pdfSize.height
        let smallerScale = fmin(widthScale, heightScale)
        CGContextScaleCTM(ctx, smallerScale, smallerScale)

        let xTranslate = (bounds.size.width - (pdfSize.width * smallerScale)) / 2.0
        let yTranslate = (bounds.size.height - (pdfSize.height * smallerScale)) / 2.0
        CGContextTranslateCTM(ctx, xTranslate, yTranslate)

        CGContextDrawPDFPage(ctx, self.pdfPage)
        CGContextRestoreGState(ctx)
    }

}
