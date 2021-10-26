//
//  ConstantStrings.swift
//  IOSmCommerceCartPlug
//
//  Created by admin on 10/05/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
/// This class is used for those messages which are reused in project and if want to change can easily change and it get reflect in all classes where its been used.
class ConstantStrings: NSObject {

}
/** API with their titles */
struct API {
    static let GET_ALL_PRODUCT_FOR_CART = "api/cart/GetAllProductInCart"
    static let POST_UPDATE_QUANTITY_FOR_PRODUCT = "api/cart/UpdateQuantityForProduct"
    static let POST_REMOVE_PRODUCT_FROM_CART = "api/cart/RemoveProductFromCart"
    
}
 /// Alert view  messages and titles
struct AlertMessage {
    static let CHECKOUT_TITLE = "Alert"
    static let CHECKOUT_DESC = "Checkout Successfully"
    
    static let SHOP_NOW_TITLE = "Alert"
    static let SHOP_NOW_DESC = "OOPs! No more items in the cart"
    
}
 /// Error  messages and titles
struct ErrorMessage {
    static let NETWORK_TITLE = "Ooops! No Internet Connection"
    static let NETWORK_DESC = "Please check your internet connection and try again."
    
    static let SERVER_TITLE = "Error"
    static let SERVER_DESC = "Something went wrong."
    
    static let EMPTY_TITLE = "Ooops! No Results found"
    static let EMPTY_DESC = "Please try again later or try something else"
    
}
/// Action Titles
struct ActionTitle {
    static let OK = "Ok"
    static let CANCEL = "Cancel"
}
/// To check the API status code
struct StatusCode {
    static let SUCCESS = "10"
    static let FAILER = "20"
    static let USER_NOT_EXIST = "30"
}



