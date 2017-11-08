//
//  ViewController.swift
//  loginTestApp
//
//  Created by Colin Walsh on 11/8/17.
//  Copyright © 2017 Colin Walsh. All rights reserved.
//

import UIKit
import Foundation
import FacebookLogin
import FBSDKLoginKit


class ViewController: UIViewController, LoginButtonDelegate {
    
    var dict: [String : AnyObject]!
    let loginButton = LoginButton(readPermissions: [ .publicProfile ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.delegate = self
        
        //creating button
      
        
        
        if let _ = FBSDKAccessToken.current(){
            getFBUserData()
        }
        //adding it to view
        loginButton.center = view.center
        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loginButtonClicked() {
        
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
                self.getFBUserData()
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("logged out")
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if (FBSDKAccessToken.current() != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let resultData = result else {return}
                
                print(resultData)
                
                guard let returnDict = resultData as? [String: AnyObject] else {return}
                
                print(returnDict)
                
                self.dict = returnDict
                
                
                
            })
                /*.start(completionHandler: { (connection, result, error) -> Void in
                
               
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })*/
        }
    }

}

