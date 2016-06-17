final class VerticalStripCell: UICollectionViewCell {

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = Colors.darkBlue
        label.font = Fonts.largeBody
        return label
    }()

    func commonInit() {
        backgroundColor = UIColor.whiteColor()
        label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        label.frame = bounds
        addSubview(label)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
}
