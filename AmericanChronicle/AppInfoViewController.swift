import UIKit

@objc(AppInfoViewController)
class AppInfoViewController: UITableViewController {
    var collections: [String: AnyObject] = [:]

    var collectionKeysInOrder: [String] {
        return Array(collections.keys).sort(<)
    }

    func infoForItemAtIndexPath(indexPath: NSIndexPath) -> (text: String,
            detailText: String?,
            accessoryType: UITableViewCellAccessoryType,
            item: AnyObject)? {

        func detailTextForItem(item: AnyObject?) -> String? {
            if let dict = item as? [String: AnyObject] {
                return "Dictionary (\(dict.count) items)"
            } else if let arr = item as? [AnyObject] {
                return "Array (\(arr.count) items)"
            } else if let printableItem = item as? CustomStringConvertible {
                return printableItem.description
            }
            return nil
        }

        func accessoryTypeForItem(item: AnyObject?) -> UITableViewCellAccessoryType {
            if let _ = item as? [String: AnyObject] {
                return .DisclosureIndicator
            } else if let _ = item as? [AnyObject] {
                return .DisclosureIndicator
            }
            return .None
        }

        let collection: AnyObject? = collections[collectionKeysInOrder[indexPath.section]]
        if let sectionDict = collection as? [String: AnyObject] {
            let sortedKeys = Array(sectionDict.keys).sort(<)
            let rowKey = sortedKeys[indexPath.row]
            if let item: AnyObject = sectionDict[rowKey] {
                return (rowKey, detailTextForItem(item), accessoryTypeForItem(item), item)
            }
        } else if let sectionArray = collection as? [AnyObject] {
            let item: AnyObject = sectionArray[indexPath.row]
            return ("[\(indexPath.row)]", detailTextForItem(item), accessoryTypeForItem(item), item)
        }
        return nil
    }

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(AppInfoCell.self, forCellReuseIdentifier: "Cell")
    }

    // MARK: UITableViewDelegate methods

    override func tableView(tableView: UITableView,
                            shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let (_, _, accessoryType, _) = infoForItemAtIndexPath(indexPath) {
            return accessoryType == .DisclosureIndicator
        }
        return false
    }

    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let (text, _, _, obj) = infoForItemAtIndexPath(indexPath) {
            let vc = AppInfoViewController()
            vc.navigationItem.title = text
            vc.collections = [text: obj]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: UITableViewDataSource methods

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = collectionKeysInOrder[section]
        if let val = collections[key] as? [String: AnyObject] {
            return val.count
        } else if let val = collections[key] as? [AnyObject] {
            return val.count
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! AppInfoCell
        if let (text, detailText, accessoryType, _) = infoForItemAtIndexPath(indexPath) {
            cell.textLabel?.text = text
            cell.detailTextLabel?.text = detailText
            cell.accessoryType = accessoryType
        } else {
            cell.textLabel?.text = nil
            cell.detailTextLabel?.text = nil
            cell.accessoryType = .None
        }
        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return collections.count
    }

    override func tableView(tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return collectionKeysInOrder[section]
    }
}

class AppInfoCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)

        textLabel?.font = UIFont(stitchfix: .BrandonGrotesqueMedium, size: 16.0)
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.marginToSuperview(top: 16, trailing: 20, leading: 20)

        detailTextLabel?.font = UIFont(stitchfix: .BrandonGrotesqueRegular, size: 14.0)
        detailTextLabel?.translatesAutoresizingMaskIntoConstraints = false
        detailTextLabel?.marginToSuperview(trailing: 16, bottom: 20, leading: 20)
        detailTextLabel?.align(.Top, toItem: textLabel, toAttribute: .Bottom, constant: 10.0)
        detailTextLabel?.numberOfLines = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
