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
    var shareWireframe: ShareWireframe?

    public init(remoteURL: NSURL, id: String, searchTerm: String?, date: NSDate?, lccn: String?, edition: Int?, sequence: Int?) {

        // Create the view
        let sb = UIStoryboard(name: "Page", bundle: nil)
        view = sb.instantiateInitialViewController() as! PageViewController

        // Create the interactor
        dataManager = PageDataManager()
        interactor = PageInteractor(remoteURL: remoteURL, id: id, date: date, lccn: lccn, edition: edition, sequence: sequence, dataManager: dataManager)

        // Create the presenter
        presenter = PagePresenter(view: view, interactor: interactor, searchTerm: searchTerm)

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

    public func userDidTapShare(image: UIImage?) {
        if let vc = view as? PageViewController, image = image {
            shareWireframe = ShareWireframe(image: image)
            shareWireframe?.beginFromViewController(vc)
        }
    }

}
