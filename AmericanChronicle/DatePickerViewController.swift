// MARK: -
// MARK: DatePickerUserInterface

protocol DatePickerUserInterface {
    var delegate: DatePickerUserInterfaceDelegate? { get set }
    var selectedDayMonthYear: DayMonthYear { get set }
    var title: String? { get set }
}

// MARK: -
// MARK: DatePickerUserInterfaceDelegate

protocol DatePickerUserInterfaceDelegate: class {
    func userDidSave(dayMonthYear: DayMonthYear)
    func userDidCancel()
}

// MARK: -
// MARK: DatePickerViewController

final class DatePickerViewController: UIViewController, DatePickerUserInterface, DateTextFieldDelegate {

    // MARK: Properties

    weak var delegate: DatePickerUserInterfaceDelegate?
    var selectedDayMonthYear: DayMonthYear

    private let foregroundPanel: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.whiteColor()
        return v
    }()
    private let earliestPossibleDayMonthYear: DayMonthYear
    private let latestPossibleDayMonthYear: DayMonthYear
    private let dateField = DateTextField()
    private let navigationBar = UINavigationBar()

    // MARK: Init methods

    init(earliestPossibleDayMonthYear: DayMonthYear = Search.earliestPossibleDayMonthYear,
         latestPossibleDayMonthYear: DayMonthYear = Search.latestPossibleDayMonthYear) {
        self.earliestPossibleDayMonthYear = earliestPossibleDayMonthYear
        self.latestPossibleDayMonthYear = latestPossibleDayMonthYear
        selectedDayMonthYear = earliestPossibleDayMonthYear

        super.init(nibName: nil, bundle: nil)

        navigationItem.setLeftButtonTitle("Cancel",
                                          target: self,
                                          action: #selector(didTapCancelButton(_:)))
        navigationItem.setRightButtonTitle("Save",
                                           target: self,
                                           action: #selector(didTapSaveButton(_:)))
    }

    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("init(nibName:bundle) not supported. Use designated initializer instead")
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported. Use designated initializer instead")
    }

    @available(*, unavailable)
    init() {
        fatalError("init not supported. Use designated initializer instead")
    }

    // MARK: Internal methods

    func didTapSaveButton(sender: UIBarButtonItem) {
        delegate?.userDidSave(selectedDayMonthYear)
    }

    func didTapCancelButton(sender: UIBarButtonItem) {
        delegate?.userDidCancel()
    }

    func didRecognizeTap(sender: UITapGestureRecognizer) {
        delegate?.userDidCancel()
    }

    // MARK: DateTextFieldDelegate methods

    func selectedDayMonthYearDidChange(dayMonthYear: DayMonthYear?) {
        if let dayMonthYear = dayMonthYear {
            selectedDayMonthYear = dayMonthYear
        }
    }

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        let tapAction = #selector(didRecognizeTap(_:))
        let tap = UITapGestureRecognizer(target: self,
                                         action: tapAction)
        view.addGestureRecognizer(tap)

        view.addSubview(foregroundPanel)
        foregroundPanel.snp_makeConstraints { make in
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(360)
        }


        foregroundPanel.addSubview(navigationBar)
        navigationBar.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        navigationBar.pushNavigationItem(navigationItem, animated: false)

        dateField.delegate = self
        dateField.selectedDayMonthYear = selectedDayMonthYear
        foregroundPanel.addSubview(dateField)
        dateField.snp_makeConstraints { make in
            make.top.equalTo(navigationBar.snp_bottom).offset(20.0)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.height.equalTo(66)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dateField.becomeFirstResponder()
    }
}
