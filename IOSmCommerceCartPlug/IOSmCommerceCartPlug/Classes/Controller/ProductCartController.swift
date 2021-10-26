//
//  ProductCartController.swift
//  IOSmCommerceCartPlug
//  id = 160
//  Created by admin on 10/05/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
/// This class is used to show the product added to cart.
class ProductCartController: ProductCartBase {
    
    @IBOutlet weak var tblViewForProductDetails: UITableView!
    @IBOutlet weak var scrollViewForCart: UIScrollView!
    @IBOutlet weak var tblViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewForProductPriceDetails: UIView!
    @IBOutlet weak var productCostDetailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewForActivityIndicator: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // Outlets For Total Number of Items Added to Cart
    @IBOutlet weak var lblForNumberofItems: UILabel!
    @IBOutlet weak var lblForTotalNumberofItems: UILabel!
    @IBOutlet weak var viewForCostDetail: UIView!
    @IBOutlet weak var lblForPriceDetails: UILabel!
    //Outlets For Price Details
    @IBOutlet weak var lblForTotalMRP: UILabel!
    @IBOutlet weak var lblForDeliveryCharges: UILabel!
    @IBOutlet weak var lblForProductTotal: UILabel!
    //Outlets For Product Price and Checkout Button
    @IBOutlet weak var lblForProductTotalPrice: UILabel!
    @IBOutlet weak var imgViewForArrow: UIImageView!
    @IBOutlet weak var btnForCheckout: UIButton!
    @IBOutlet weak var viewForCheckoutButton: UIView!
    
    @IBOutlet weak var imgForArrow: UIImageView!
    var userId = 0
    var productCartArray = [[String: Any]]()
    var productTotalCost:Float = 0.0
    var productDetails = NSDictionary()
    var cost:String?
    var deliveryCost:String?
    var isFromShopNow = false
    var currentProductCount = 1
    var totalMRPofProduct = 0.0
    var totalCostDict = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(productTotalCost)
        print(productCartArray)
        DispatchQueue.main.async {
            self.tblViewForProductDetails.reloadData()
        }
  
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ProductCartController.navigateToCategory), name: NSNotification.Name(rawValue:""), object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:""), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getAllProductForCartAPI(from: "getAllProduct")
    }
    /// start loader
    func startActivityLoader() {
        activityIndicator.isHidden = false
        viewForActivityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    /// stop loader
    func stopActivityLoader() {
        activityIndicator.isHidden = true
        viewForActivityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    /// This function is used to increase or decrease product count
    @IBAction func btnForIncrementandDecrementofProductCount(_ sender:UIButton) {
        let buttonPostion = sender.convert(sender.bounds.origin, to: tblViewForProductDetails)
        if let indexPath = tblViewForProductDetails.indexPathForRow(at: buttonPostion) {
            let cell = self.tblViewForProductDetails.cellForRow(at: indexPath) as! ProductCartTableViewCell
            let cartArray = self.productCartArray[indexPath.row]
            let productId = cartArray["productId"] as! Int
            let productSizeId = cartArray["productSizeId"] as! Int
            let quantityofproduct = cartArray["quantity"] as! Int
            print(quantityofproduct)
            if sender.tag == 10 {
                var currentProductCountForDecr = Int(cell.lblForProductCountIncDecr.text!)!
                currentProductCountForDecr = quantityofproduct-1
                if currentProductCountForDecr > 0  //To avoid negative decrement of values
                {
                    self.updateQuantityforProduct(productId: productId, quantity: currentProductCountForDecr, userId: userId, productSizeId: productSizeId)
                } else {
                    print("show alert to user, 'Are you sure want to remove product from cart?' ")
                }
            } else if sender.tag == 11 {
                var currentProductCount = Int(cell.lblForProductCountIncDecr.text!)
                currentProductCount = quantityofproduct+1
                if currentProductCount! < 11  //To not allow add more than 10 quantity of this product
                {
                    self.updateQuantityforProduct(productId: productId, quantity: currentProductCount!, userId: userId, productSizeId: productSizeId)
                } else {
                    self.showToast(message: "Maximum limit is 10")
                }
            }
        }
    }
    /// This function is used to remove product from cart
    @IBAction func removeProductFromCart(_ sender: UIButton) {
        if GeneralClass.isConnectedToNetwork() //if no network
        {
            self.removeChildVC()
            let buttonPostion = sender.convert(sender.bounds.origin, to: tblViewForProductDetails)
            if let indexPath = tblViewForProductDetails.indexPathForRow(at: buttonPostion) {
                let cartArray = self.productCartArray[indexPath.row]
                let productId = cartArray["productId"] as! Int
                let productSizeId = cartArray["productSizeId"] as! Int
                let jsonRemoveProductFromCart : Dictionary!  = ["ProductId":"\(productId)","UserId":"\(userId)","ProductSizeId":"\(productSizeId)"]
                self.startActivityLoader()
                removeProductFromCart(json : jsonRemoveProductFromCart) { (data) in
                    self.stopActivityLoader()
                    if (data != nil) {
                        if let resp = data as NSDictionary? {
                            print(resp)
                            if let statusCode = resp.value(forKey: "statusCode") as? String, statusCode == "10" {
                                self.showToast(message: "Product remove successfully")
                                self.getAllProductForCartAPI(from: "removeProduct")
                            }
                        }
                    }
                }
            }
        } else {
            self.isFromShopNow = false
            self.addErrorView(title: ErrorMessage.NETWORK_TITLE, message: ErrorMessage.NETWORK_DESC)
        }
    }
    /// This function is used to show the popup on click of checkout
    @IBAction func btnForCheckOut(_ sender: Any) {
        if GeneralClass.isConnectedToNetwork()
        {
            self.showAlertView(title: AlertMessage.CHECKOUT_TITLE, message: AlertMessage.CHECKOUT_DESC)
        } else {
            self.showAlertView(title: ErrorMessage.NETWORK_TITLE, message: ErrorMessage.NETWORK_DESC)
        }
    }
 
    /// This function is used to naviagte to category
    @objc func navigateToCategory () {
        
        if GeneralClass.isConnectedToNetwork()
        {
            if isFromShopNow == true {
                
                self.showAlertView(title: AlertMessage.SHOP_NOW_TITLE, message: AlertMessage.SHOP_NOW_DESC
                )
            } else {
                self.getAllProductForCartAPI(from: "")
            }
        } else {
            self.isFromShopNow = false
            self.addErrorView(title: ErrorMessage.NETWORK_TITLE, message: ErrorMessage.NETWORK_DESC)
        }
    }
    /// func for get all Product For Cart API
    @objc func getAllProductForCartAPI(from: String) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "NoInternetController") as! NoInternetController
        if GeneralClass.isConnectedToNetwork () {
            self.removeChildVC()
            self.userId = 83
            self.startActivityLoader()
            if(from == "getAllProduct") {
                self.scrollViewForCart.isHidden = true
            }
            self.startActivityLoader()
            getAllProductFromCart(query : "?userId=\(userId)" ) { (data) in
                self.stopActivityLoader()
                if(from == "getAllProduct"){
                    self.scrollViewForCart.isHidden = false
                }
                if (data != nil) {
                    if let resp = data as NSDictionary? {
                        print("Get all product for cart \(resp)")
                        let productTotalCost = resp.value(forKeyPath: "data.totalCost") as! String
                        print(productTotalCost)
                        self.lblForTotalMRP.text = "₹" + "" + "\(productTotalCost)"
                        let productDeliveryCharges = resp.value(forKeyPath: "data.totalDeliveryCharges") as! String
                        print(productDeliveryCharges)
                        self.lblForDeliveryCharges.text = "₹" + "" + "\(productDeliveryCharges)"
                        let total = Double(productTotalCost )!  + Double(productDeliveryCharges )!
                        print(total)
                        self.lblForProductTotal.text = "₹" + "" + "\(String(total))"
                        self.lblForProductTotalPrice.text =  "₹" + "" + "\(String(total))"
                        if let productCartResp = resp.value(forKeyPath: "data.productList") as? NSArray {
                            print(productCartResp.count)
                            self.productCartArray = productCartResp as! [[String : Any]]
                            print(self.productCartArray)
                            print(self.totalMRPofProduct)
                            if self.productCartArray.isEmpty {
                                self.addChild(controller)
                                controller.view.frame.origin.y = 0
                                self.view.addSubview(controller.view)
                                controller.lblForTitleMessage.text = "Your Cart is empty!"
                                controller.lblForTitleDesc.text = "Add items to it now"
                                controller.btnForTryAgain.setTitle("Shop Now",for: .normal)
                                self.isFromShopNow = true
                                controller.didMove(toParent: self)
                            } else {
                                self.refreshCartTable()
                            }
                            self.tblViewForProductDetails.reloadData()
                        }
                    }
                }
            }
        } else {
            self.addErrorView(title: ErrorMessage.NETWORK_TITLE, message: ErrorMessage.NETWORK_DESC)
            self.isFromShopNow = false
        }
        
    }
    /// This function is used to update the quantity of product
    func updateQuantityforProduct(productId:Int,quantity:Int,userId:Int,productSizeId:Int) {
        print(currentProductCount)
        let jsonupdateQuantityforProduct : Dictionary!  = ["ProductId":"\(productId)","Quantity":"\(quantity)","UserId":"\(userId)","ProductSizeId":"\(productSizeId)"]
        updateQuantityforProduct(json : jsonupdateQuantityforProduct )
        { (data) in
            if (data != nil) {
                if let resp = data as NSDictionary? {
                    print(resp)
                    self.getAllProductForCartAPI(from: "updateQuantity")
                }
            }
        }
    }
    /// This function is used to refresh the cart table
    func refreshCartTable () {
        let numberofProducts:Int =  productCartArray.count
        self.lblForNumberofItems.text = "(" + String(numberofProducts) + ")"
        self.lblForTotalNumberofItems.text = "(" + String(numberofProducts) + " Items)"
        let cellHeight = 175
        let totalItemViewHeight = CGFloat(60.0)
        let height_costDetailView = CGFloat(185.0)
        let height_tblView = CGFloat(self.productCartArray.count * cellHeight)
        self.tblViewHeightConstraints.constant = height_tblView
        self.productCostDetailTopConstraint.constant = height_tblView + 70
        self.scrollViewForCart.contentSize = CGSize(width: (self.view.frame.size.width), height:(height_tblView + height_costDetailView + totalItemViewHeight))
        tblViewForProductDetails.reloadData()
    }
  
}
/// UITableView DataSource
extension ProductCartController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productCartArray.count
    }
}
/// UITableView Delegate
extension ProductCartController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCartTableViewCell
        let cartArray = self.productCartArray[indexPath.row]
        cell.imgViewForProduct.layer.borderWidth = 2.0
        cell.imgViewForProduct.layer.masksToBounds = true
        cell.imgViewForProduct.layer.borderColor = UIColor.lightGray.cgColor
        cell.viewForCount.layer.borderColor = UIColor.gray.cgColor
        cell.viewForCount.layer.borderWidth = 1
        cell.viewForCount.layer.cornerRadius = 3
        cell.viewForProductDetails.layer.borderColor = UIColor.gray.cgColor
        cell.viewForProductDetails.layer.borderWidth = 1
        cell.viewForProductDetails.layer.cornerRadius = 10
        cell.lblForProductName.text = cartArray["productName"] as? String
        cell.lblForProductCategory.text = cartArray["productCategory"] as? String
        cell.lblForProductQuantity.text = cartArray[ "sizeValue"] as? String
        cell.lblForProductPrice.text = "₹" + "" + "\((cartArray["price"] as? String)!)"
        cell.lblForProductCountIncDecr.text = "\(String(describing: cartArray["quantity"] as! Int))"
        let str = cartArray["imageUrl"] as? String
        if let url = str, let imageUrl = URL(string: url) {
            cell.imgViewForProduct.af_setImage(withURL:imageUrl,placeholderImage:Image(named: "ic_placeholder"))
        } else {
            cell.imgViewForProduct.image = Image(named: "ic_placeholder_category")
        }
        return cell
    }
}

