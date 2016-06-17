// MARK: -
// MARK: USStatePickerUserInterface protocol

protocol USStatePickerUserInterface {
    var delegate: USStatePickerUserInterfaceDelegate? { get set }
    var stateNames: [String] { get set }
    func setSelectedStateNames(selectedStates: [String])
}

// MARK: -
// MARK: USStatePickerUserInterfaceDelegate protocol

protocol USStatePickerUserInterfaceDelegate: class {
    func userDidTapSave(selectedStateNames: [String])
    func userDidTapCancel()
}

// MARK: -
// MARK: USStatePickerViewController class

final class USStatePickerViewController: UICollectionViewController, USStatePickerUserInterface {

    // MARK: Properties

    weak var delegate: USStatePickerUserInterfaceDelegate?
    var stateNames: [String] = []

    // MARK: Init methods

    func commonInit() {
        navigationItem.title = "U.S. States"
        navigationItem.setLeftButtonTitle("Cancel", target: self, action: #selector(didTapCancelButton(_:)))
        navigationItem.setRightButtonTitle("Save", target: self, action: #selector(didTapSaveButton(_:)))
    }

    convenience init() {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: Internal methods

    func setSelectedStateNames(selectedStates: [String]) {
        for selectedState in selectedStates {
            if let idx = stateNames.indexOf(selectedState) {
                collectionView?.selectItemAtIndexPath(
                    NSIndexPath(forItem: idx, inSection: 0),
                    animated: false,
                    scrollPosition: UICollectionViewScrollPosition.None)
            }

        }
    }

    func didTapCancelButton(sender: UIButton) {
        delegate?.userDidTapCancel()
    }

    func didTapSaveButton(sender: UIButton) {
        let selectedIndexPaths = collectionView?.indexPathsForSelectedItems() ?? []
        let selectedStateNames = selectedIndexPaths.map { self.stateNames[$0.item] }
        delegate?.userDidTapSave(selectedStateNames)
    }

    // MARK: UICollectionViewDelegateFlowLayout methods

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let columnCount = 1

        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let left = flowLayout?.sectionInset.left ?? 0
        let right = flowLayout?.sectionInset.right ?? 0
        let totalInteritemSpacing = (flowLayout?.minimumInteritemSpacing ?? 0) * CGFloat(columnCount - 1)
        let availableWidth = collectionView.bounds.width - (left + totalInteritemSpacing + right)
        let columnWidth = availableWidth/CGFloat(columnCount)
        return CGSize(width: columnWidth, height: Measurements.buttonHeight)
    }

    // MARK: UICollectionViewController overrides

    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return stateNames.count
    }

    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: USStateCell = collectionView.dequeueCellForItemAtIndexPath(indexPath)
        cell.label.text = stateNames[indexPath.row]
        return cell
    }

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.registerClass(USStateCell.self,
                                      forCellWithReuseIdentifier: NSStringFromClass(USStateCell.self))
        collectionView?.allowsMultipleSelection = true
        collectionView?.backgroundColor = Colors.lightBackground.colorWithAlphaComponent(0.8)
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: Measurements.verticalMargin,
                                            left: Measurements.horizontalMargin,
                                            bottom: Measurements.verticalMargin,
                                            right: Measurements.horizontalMargin)
        layout?.minimumInteritemSpacing = 1.0
        layout?.minimumLineSpacing = 1.0
    }
}
