//
//  HomeViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit


class HomeViewController: UITableViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {

    
    @IBOutlet weak var searchField: SearchField!
    var statesByName = FakeData.statesByName()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func newspaperAtIndexPath(indexPath: NSIndexPath) -> Newspaper? {
        if let state = statesByName[StateName.alphabeticalList[indexPath.section]] {
            return state.newspapers[indexPath.row]
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")

        searchField.shouldBeginEditingCallback = {
            let sb = UIStoryboard(name: "Search", bundle: nil)
            if let nvc = sb.instantiateInitialViewController() as? UINavigationController,
               let vc = nvc.topViewController as? SearchViewController {
                vc.cancelCallback = { [weak self] in
                    self?.dismissViewControllerAnimated(true, completion: nil)
                }
                nvc.modalPresentationStyle = .Custom
                nvc.transitioningDelegate = self
                self.presentViewController(nvc, animated: true, completion: nil)
            }
            return false
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow(), let paper = newspaperAtIndexPath(indexPath) {
                (segue.destinationViewController as! NewspaperIssuesViewController).newspaper = paper
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return statesByName.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let state = statesByName[StateName.alphabeticalList[section]] {
            return state.newspapers.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as? TableHeaderView
        headerView?.label.text = StateName.alphabeticalList[section].rawValue
        return headerView
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        if let paper = newspaperAtIndexPath(indexPath) {
            cell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: UIFont.systemFontSize())
            cell.textLabel?.textColor = UIColor.darkTextColor()
            cell.textLabel?.text = paper.title

            cell.detailTextLabel?.font = UIFont(name: "AvenirNext-Regular", size: UIFont.smallSystemFontSize())
            cell.detailTextLabel?.textColor = UIColor.darkTextColor()
            cell.detailTextLabel?.text = paper.city.name
        } else {
            cell.textLabel?.text = nil
            cell.detailTextLabel?.text = nil
        }

        return cell
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }

    // MARK: UIViewControllerTransitioningDelegate methods

    func animationControllerForPresentedController(presented: UIViewController,
                                                   presentingController presenting: UIViewController,
                                                   sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                                                    return TransitionController()
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionController()
    }

    //func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    //}

    //func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    //}

//    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
//        return PresentationController()
//    }

}

class TransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromNVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? UINavigationController
        let toNVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? UINavigationController
        if let fromVC = fromNVC?.topViewController as? HomeViewController  {
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                toView.alpha = 0
                transitionContext.containerView().addSubview(toView)
                UIView.animateWithDuration(duration, animations: {
                    toView.alpha = 1.0
                    }, completion: { _ in
                        transitionContext.completeTransition(true)
                })
            }
        } else {
            if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
                UIView.animateWithDuration(duration, animations: {
                    fromView.alpha = 0
                }, completion: { _ in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                })
            }
        }

    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }
}

class PresentationController: UIPresentationController {

}