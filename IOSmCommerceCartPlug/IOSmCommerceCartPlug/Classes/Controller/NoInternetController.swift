//
//  NoInternetController.swift
//  IOSmCommerceCartPlug
//
//  Created by admin on 10/05/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
/// This class is used for showing the screen when No internet connection is there
class NoInternetController: UIViewController {
    /// This are all IBOutlets for Nointernet controller class
    @IBOutlet weak var btnForTryAgain: UIButton!
    @IBOutlet weak var imgViewForNoInternetConnection: UIImageView!
    @IBOutlet weak var lblForTitleMessage: UILabel!
    @IBOutlet weak var lblForTitleDesc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    /// This function is used the internet connection is there or not accordingly it display a view
    @IBAction func btnForTryAgain(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: ""), object: self)
    }
}
