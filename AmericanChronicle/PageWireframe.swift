//
//  PageWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/12/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

public class PageWireframe: NSObject {

    let view: PageViewInterface
    let presenter: PagePresenterInterface
    let interactor: PageInteractorInterface
    let dataManager: PageDataManagerInterface

    public init(remoteURL: NSURL, date: NSDate, lccn: String, edition: Int, sequence: Int) {

        // Create the view
        let sb = UIStoryboard(name: "Page", bundle: nil)
        view = sb.instantiateInitialViewController() as! PageViewController

        // Create the interactor
        dataManager = PageDataManager()
        interactor = PageInteractor(remoteURL: remoteURL, date: date, lccn: lccn, edition: edition, sequence: sequence, dataManager: dataManager)

        // Create the presenter
        presenter = PagePresenter(view: view, interactor: interactor)

        super.init()

        
        presenter.wireframe = self
    }

    public func beginFromViewController(parentModuleViewController: UIViewController?, withRemoteURL remoteURL: NSURL) {
        if let vc = view as? PageViewController {
            parentModuleViewController?.presentViewController(vc, animated: true, completion: nil)
        }
        presenter.startDownload()
    }

    public func userDidTapDone() {
        if let vc = view as? PageViewController {
            vc.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    private func share() {
        //                let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        //                vc.completionWithItemsHandler = { type, completed, returnedItems, activityError in
        //                    self.toastButton.frame = CGRect(x: 20.0, y: self.bottomBarBG.frame.origin.y - 80.0, width: self.view.bounds.size.width - 40.0, height: 60)
        //                    let message: String = ""
        //                    if type == nil {
        //                        return
        //                    }
        //                    //            switch type {
        //                    //            case UIActivityTypeSaveToCameraRoll:
        //                    //                message = completed ? "Page saved successfully" : "Trouble saving, please try again"
        //                    //            default:
        //                    //                message = completed ? "Success" : "Action failed, please try again"
        //                    //            }
        //
        //                    self.toastButton.setTitle(message, forState: .Normal)
        //                    self.toastButton.alpha = 0
        //                    self.toastButton.hidden = false
        //                    UIView.animateWithDuration(0.2, animations: {
        //                        self.toastButton.alpha = 1.0
        //                        }, completion: { _ in
        //                            UIView.animateWithDuration(0.2, delay: 3.0, options: UIViewAnimationOptions(), animations: {
        //                                self.toastButton.alpha = 0
        //                                }, completion: { _ in
        //                                    self.toastButton.hidden = true
        //                            })
        //                    })
        //                }
        //                presentViewController(vc, animated: true, completion: nil)
        //            }
        //            let nvc = UINavigationController(rootViewController: vc)
        //            presenting?.presentViewController(nvc, animated: true, completion: nil)
    }
}
