//
//  AppDelegate.swift
//  IOSmCommerceCartPlug
//
//  Created by admin on 07/05/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

/// AppDelegate is a singleton class in swift project
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.callToSetConfigeUrl()
        return true
        
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    // MARK:- Confige URL
    
    /// Uset to set confige url from server
    private func callToSetConfigeUrl(){
        if GeneralClass.isConnectedToNetwork(){
            if GetApiConfig.execute(){
                self.loadInitialViewController()
            } else {
                if (UserDefaults.standard.value(forKey: "StartURLFromServer") as! NSString?) == nil{
                    showErrorAlert(message: "Something went wrong. Please contact to your Admin!")
                    
                }else{
                    self.loadInitialViewController()
                }
            }
        }else{
            if (UserDefaults.standard.value(forKey: "StartURLFromServer") as! NSString?) == nil{
                self.showErrorAlert(message: "No internet available. Please check your connection.")
                
            }else{
                self.loadInitialViewController()
            }
        }
    }
      /// Used to load initial view controller
    private func loadInitialViewController(){
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController : UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "initialVC") as! UINavigationController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    /// Used to show Error alert
    func showErrorAlert(message : String){
        let alertVC = UIAlertController(title: "Oops" , message: message, preferredStyle: UIAlertController.Style.alert)
        let tryAgain = UIAlertAction(title: "Try again", style: .default) { (_) -> Void in
            self.callToSetConfigeUrl()
        }
        alertVC.addAction(tryAgain)
        DispatchQueue.main.async {
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindow.Level.alert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alertVC, animated: true, completion: nil)
        }
    }
    
}
