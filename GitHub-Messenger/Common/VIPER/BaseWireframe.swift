//
//  BaseWireframe.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 3/3/2020.
//

import UIKit

public protocol WireframeInterface: class {
    func popFromNavigationController(animated: Bool)
    func dismiss(animated: Bool)

    func showErrorAlert(with message: String?)
    func showAlert(with title: String?, message: String?)
    func showAlert(with title: String?, message: String?, actions: [UIAlertAction])
}

public class BaseWireframe {

    fileprivate unowned var _viewController: UIViewController

    //to retain view controller reference upon first access
    fileprivate var _temporaryStoredViewController: UIViewController?

    init(viewController: UIViewController) {
        _temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension BaseWireframe: WireframeInterface {
    public func popFromNavigationController(animated: Bool) {
        let _ = navigationController?.popViewController(animated: animated)
    }

    public func dismiss(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }

    public func showErrorAlert(with message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(with: "Something went wrong", message: message, actions: [okAction])
    }

    public func showAlert(with title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(with: title, message: message, actions: [okAction])
    }

    public func showAlert(with title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension BaseWireframe {

    var viewController: UIViewController {
        defer { _temporaryStoredViewController = nil }
        return _viewController
    }

    var navigationController: UINavigationController? {
        return viewController.navigationController
    }
}

extension UINavigationController {

    func pushWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.pushViewController(wireframe.viewController, animated: animated)
    }

    func setRootWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.setViewControllers([wireframe.viewController], animated: animated)
    }
}

