final class ByDecadeYearPickerCell: UICollectionViewCell {

    // MARK: Properties

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    override var highlighted: Bool {
        didSet { updateFormat() }
    }
    override var selected: Bool {
        didSet { updateFormat() }
    }

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = Fonts.largeBody
        label.textColor = Colors.darkGray
        return label
    }()
    private let insetBackgroundView: UIImageView = {
        let image = UIImage.imageWithFillColor(UIColor.whiteColor(), cornerRadius: 1.0)
        return UIImageView(image: image)
    }()

    func commonInit() {

        contentView.addSubview(insetBackgroundView)
        insetBackgroundView.snp_makeConstraints { make in
            make.edges.equalTo(contentView.snp_edges).inset(1.0)
        }

        insetBackgroundView.layer.shadowColor = Colors.darkGray.CGColor
        insetBackgroundView.layer.shadowOpacity = 0.3
        insetBackgroundView.layer.shadowRadius = 0.5
        insetBackgroundView.layer.shadowOffset = .zero

        contentView.addSubview(label)
        label.snp_makeConstraints { make in
            make.edges.equalTo(0)
        }

        updateFormat()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    private func updateFormat() {
        if self.highlighted {
            insetBackgroundView.image = UIImage.imageWithFillColor(Colors.lightBlueBright,
                                                                   cornerRadius: 1.0)
            self.label.textColor = UIColor.whiteColor()
        } else if self.selected {
            insetBackgroundView.image = UIImage.imageWithFillColor(Colors.lightBlueBright,
                                                                   cornerRadius: 1.0)
            self.label.textColor = UIColor.whiteColor()
        } else {
            insetBackgroundView.image = UIImage.imageWithFillColor(UIColor.whiteColor(),
                                                                   cornerRadius: 1.0)
            self.label.textColor = Colors.darkBlue
        }
    }
}
