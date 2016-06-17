final class EmptyResultsView: UIView {

    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    let titleLabel: UILabel = {
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
            make.bottom.equalTo(-Measurements.verticalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)

        }
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
