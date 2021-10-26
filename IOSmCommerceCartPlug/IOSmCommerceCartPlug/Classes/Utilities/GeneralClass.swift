//
//  GeneralClass.swift
//  IOSmCommerceCartPlug
//
//  Created by admin on 10/05/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import SystemConfiguration
/// This General Class is used for some function which are reused in this project
class GeneralClass: NSObject {
    /// Used to check connectivity
    ///
    /// - Returns: flag
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let isConnected = (isReachable && !needsConnection)
        
        return isConnected
    }
    
    /// Used to save image
    ///
    /// - Parameter image: image
    /// - Returns: result
    static func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 0.50) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("Profile.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /// used to get save image
    ///
    /// - Parameter named: image name
    /// - Returns: image
    static func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    static func check_null_values(value:Any!) -> Bool {
        if value is NSNull {
            return true
        }
        if value == nil {
            return true
        }
        if value is String && ((value as? String) == "(null)" || (value as? String) == "<null>"  || (value as? String) == "" || (value as? String) == "null") {
            return true
        }
        return false
    }
    
}
