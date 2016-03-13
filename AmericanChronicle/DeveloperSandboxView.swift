class DeveloperSandboxView : UIView {
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        safelyAddSubview(tableView)
        initalizeConstraints()
    }
    
    func initalizeConstraints() {
        tableView.pinToSuperview()
    }
}
