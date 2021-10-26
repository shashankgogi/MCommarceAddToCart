//
//  ProductCartBase.swift
//  IOSmCommerceCartPlug
//
//  Created by admin on 10/05/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

/// This class is used to call functions of APIs
class ProductCartBase: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    /// This function is used to call REMOVE_PRODUCT_FROM_CART API
    func removeProductFromCart(json:Dictionary<String,Any> ,completion: @escaping (Dictionary<String, Any>?) -> Void) {
        // API Call
        APIs.performPost(requestStr: API.POST_REMOVE_PRODUCT_FROM_CART, jsonData:json) { (data) in
            if (data != nil) {
                if let resp = data as? Dictionary<String, Any> {
                    completion(resp)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
     /// This function is used to call UPDATE_QUANTITY_FOR_PRODUCT API
    func updateQuantityforProduct(json:Dictionary<String,Any> ,completion: @escaping (Dictionary<String, Any>?) -> Void) {
        // API Call
        APIs.performPost(requestStr: API.POST_UPDATE_QUANTITY_FOR_PRODUCT, jsonData:json) { (data) in
            if (data != nil) {
                if let resp = data as? Dictionary<String, Any> {
                    completion(resp)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
     /// This function is used to call GET_ALL_PRODUCT_FOR_CART API
    func getAllProductFromCart(query : String,completion: @escaping (Dictionary<String, Any>?) -> Void) {
        // API Call
        APIs.performGet(requestStr: API.GET_ALL_PRODUCT_FOR_CART, query: query) { (data) in
            if (data != nil) {
                if let resp = data as? Dictionary<String, Any> {
                    completion(resp)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
}
