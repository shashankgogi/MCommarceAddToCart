//
//  UtilitiesExtensionsViewController.swift
//  IOSmCommerceCartPlug
//
//  Created by admin on 10/05/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
/// This UIView extension is used to provide corner radius,border width and border color from storyboard
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
/// This UIViewController extension is used for the function which are reused in overall projects
extension UIViewController {
    /// This func is used to add error view when no internet connection is there
    func addErrorView(title: String, message: String) {
        if let controller = storyboard!.instantiateViewController(withIdentifier: "NoInternetController") as? NoInternetController {
            self.addChild(controller)
            controller.view.frame.origin.y = 0
            self.view.addSubview(controller.view)
            controller.lblForTitleMessage.text = title
            controller.lblForTitleDesc.text = message
            controller.didMove(toParent: self)
            
        }
    }
      /// This function is used to remove the view which is previously added
    func removeChildVC() {
        if !self.children.isEmpty {
            let arrayofVC:[UIViewController] = self.children
            for viewContoller in arrayofVC{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
    }
     /// This function is used to show alert view messages with only OK button
    func showAlertView(title : String , message : String, okBtnTitle: String = ActionTitle.OK, competitionHandler:((UIAlertAction) -> Void)? = nil ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: okBtnTitle, style: UIAlertAction.Style.default, handler:competitionHandler))
        self.present(alert, animated: true, completion:nil)
    }
     /// This function is used to show alert view messages with OK and CANCEL button
    func showAlertViewWithCancel(title : String , message : String, okBtnTitle: String = ActionTitle.OK, cancelBtnTitle: String = ActionTitle.CANCEL, competitionHandler:((UIAlertAction) -> Void)? = nil ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: okBtnTitle, style: UIAlertAction.Style.default, handler:competitionHandler))
        alert.addAction(UIAlertAction(title: cancelBtnTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion:nil)
    }
    /// This function is used to show toast message
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-300, width: 300, height: 35))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(_) in
            toastLabel.removeFromSuperview()
        })
    }
}
