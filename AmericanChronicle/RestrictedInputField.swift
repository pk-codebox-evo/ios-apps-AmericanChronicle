final class RestrictedInputField: UIView, UITextFieldDelegate {

    var didBecomeActiveHandler: (() -> Void)?
    var value: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    override var inputView: UIView? {
        get { return textField.inputView }
        set { textField.inputView = newValue }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.smallBody
        label.textColor = Colors.darkGray
        label.textAlignment = .Center
        return label
    }()
    private let textField: UITextField = {
        let field = UITextField()
        field.tintColor = UIColor.clearColor() // Hide the cursor
        field.font = Fonts.largeBody
        field.borderStyle = .None
        field.textColor = Colors.darkGray
        field.textAlignment = .Center
        return field
    }()
    private let tapButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(nil, forState: .Normal)
        button.setBackgroundImage(nil, forState: .Highlighted)
        button.setBackgroundImage(nil, forState: .Selected)
        return button
    }()

    // MARK: Init methods

    init(title: String) {
        super.init(frame: .zero)

        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(12)
            make.width.equalTo(self.snp_width)
        }

        textField.inputView = inputView
        textField.inputAccessoryView = inputAccessoryView
        textField.delegate = self
        addSubview(textField)
        textField.snp_makeConstraints { make in
            make.leading.equalTo(titleLabel.snp_leading)
            make.top.equalTo(titleLabel.snp_bottom)
            make.bottom.equalTo(0)
            make.trailing.equalTo(titleLabel.snp_trailing)
        }

        tapButton.addTarget(self,
                            action: #selector(didTapButton(_:)),
                            forControlEvents: .TouchUpInside)
        addSubview(tapButton)
        tapButton.snp_makeConstraints { make in
            make.edges.equalTo(textField)
        }

    }

    override convenience init(frame: CGRect) {
        self.init(title: "")
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal methods

    func didTapButton(sender: UIButton) {
        textField.becomeFirstResponder()
    }

    // MARK: UITextFieldDelegate methods

    @objc func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.didBecomeActiveHandler?()
        return true
    }

    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    override func isFirstResponder() -> Bool {
        return textField.isFirstResponder()
    }
}
