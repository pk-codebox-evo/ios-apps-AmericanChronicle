final class ErrorView: UIView {

    // MARK: Properties

    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    var message: String? {
        get {
            return messageLabel.text
        }
        set {
            messageLabel.text = newValue
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.numberOfLines = 0
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.numberOfLines = 0
        return label
    }()

    // MARK: Init methods

    func commonInit() {
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.top.equalTo(Measurements.verticalMargin)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }
        addSubview(messageLabel)
        messageLabel.snp_makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(Measurements.horizontalMargin)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.bottom.equalTo(-Measurements.verticalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
}
