final class PDFPageView: UIView {

    // MARK: Properties

    var pdfPage: CGPDFPageRef? {
        didSet { layer.setNeedsDisplay() }
    }
    var highlights: OCRCoordinates? {
        didSet { layer.setNeedsDisplay() }
    }

    // MARK: Init methods

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

    // MARK: UIView overrides

    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {

        // Draw a blank white background (in case pdfPage is empty).
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0)
        CGContextFillRect(ctx, bounds)

        pdfPage?.drawInContext(ctx, boundingRect: bounds, withHighlights: highlights)
    }
}
