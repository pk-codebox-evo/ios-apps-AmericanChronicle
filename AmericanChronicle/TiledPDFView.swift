//
//  TiledPDFView.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/29/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class TiledPDFView: UIView {

    var pdfPage: CGPDFPageRef?

    var tiledLayer: CATiledLayer? {
        return self.layer as? CATiledLayer
    }

    func commonInit() {
//        tiledLayer?.levelsOfDetail = 4
//        tiledLayer?.levelsOfDetailBias = 3
//        tiledLayer?.tileSize = CGSize(width: 512.0, height: 512.0)
        tiledLayer?.borderColor = UIColor.lightGrayColor().CGColor
        tiledLayer?.borderWidth = 5.0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    override class func layerClass() -> AnyClass {
        return CATiledLayer.self
    }

    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {

        print("[RP] ENTERING drawLayer(::)")
//
//        print("[RP]  * bounds: \(bounds)")
//        print("[RP]  * frame: \(frame)")
//        print("[RP]  * pdfPage: \(pdfPage)")
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
        CGContextFillRect(ctx, bounds);

        // Print a blank page and return if our page is null.
        if pdfPage == nil { return }

        CGContextSaveGState(ctx)

        // Flip the context so that the PDF page is rendered right side up.
        CGContextTranslateCTM(ctx, 0.0, bounds.size.height)
        CGContextScaleCTM(ctx, 1.0, -1.0)

        // Scale the context so that the PDF page is rendered at the correct size for the zoom level.
        let mediaBoxRect = CGPDFPageGetBoxRect(pdfPage, .MediaBox)
        let widthScale = bounds.size.width/mediaBoxRect.size.width
        let heightScale = bounds.size.height/mediaBoxRect.size.height
        CGContextScaleCTM(ctx, widthScale, heightScale)

        CGContextDrawPDFPage(ctx, self.pdfPage)
        CGContextRestoreGState(ctx)

        print("[RP] EXITING drawLayer(::)")
    }
}
