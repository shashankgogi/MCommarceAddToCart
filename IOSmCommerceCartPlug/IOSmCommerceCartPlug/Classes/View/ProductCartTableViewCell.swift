//
//  ProductCartTableViewCell.swift
//  IOSmCommerceCartPlug
//
//  Created by admin on 10/05/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
/// This class is used for table view @IBOutlet
class ProductCartTableViewCell: UITableViewCell {
    /// This are  @IBOutlet of ProductCart
    @IBOutlet weak var imgViewForProduct: UIImageView!
    @IBOutlet weak var lblForProductName: UILabel!
    @IBOutlet weak var lblForProductCategory: UILabel!
    @IBOutlet weak var lblForProductQuantity: UILabel!
    @IBOutlet weak var lblForProductPrice: UILabel!
    @IBOutlet weak var lblForProductCountIncDecr: UILabel!
    @IBOutlet weak var viewForProductDetails: UIView!
    @IBOutlet weak var viewForCount: UIView!
    @IBOutlet weak var btnForDecrement: UIButton!
    @IBOutlet weak var btnForIncrement: UIButton!
}
