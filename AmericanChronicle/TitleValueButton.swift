final class TitleValueButton: UIControl {

    // MARK: Properties

    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    var value: String? {
        get { return valueLabel.text }
        set { valueLabel.text = newValue }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.highlightedTextColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.font = Fonts.smallBody
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.lightBlueBright
        label.highlightedTextColor = UIColor.whiteColor()
        label.font = Fonts.mediumBody
        label.textAlignment = .Center
        return label
    }()
    private let button: UIButton = {
        let b = UIButton()
        b.setBackgroundImage(UIImage.imageWithFillColor(UIColor.whiteColor(), cornerRadius: 1.0), forState: .Normal)
        b.setBackgroundImage(UIImage.imageWithFillColor(Colors.lightBlueBright, cornerRadius: 1.0), forState: .Highlighted)
        return b
    }()

    // MARK: Init methods

    init(title: String, initialValue: String = "--") {
        super.init(frame: .zero)

        layer.shadowColor = Colors.darkGray.CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 0.5
        layer.shadowOpacity = 0.4

        button.addTarget(self, action: #selector(didTapButton(_:)), forControlEvents: .TouchUpInside)
        button.addObserver(self, forKeyPath: "highlighted", options: NSKeyValueObservingOptions.Initial, context: nil)
        addSubview(button)
        button.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }

        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.top.equalTo(5)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
        }

        valueLabel.text = initialValue
        addSubview(valueLabel)
        valueLabel.snp_makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(2)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
        }
    }

    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(*, unavailable)
    init() {
        fatalError("init() has not been implemented")
    }

    // MARK: Internal methods

    func didTapButton(sender: UIButton) {
        sendActionsForControlEvents(.TouchUpInside)
    }

    // MARK: NSKeyValueObserving methods

    override func observeValueForKeyPath(keyPath: String?,
                                         ofObject object: AnyObject?,
                                                  change: [String : AnyObject]?,
                                                  context: UnsafeMutablePointer<Void>) {
        highlighted = button.highlighted
    }

    // MARK: UIControl overrides

    override var highlighted: Bool {
        didSet {
            titleLabel.highlighted = highlighted
            valueLabel.highlighted = highlighted
        }
    }

    // MARK: UIView overrides

    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: Measurements.buttonHeight)
    }
}
