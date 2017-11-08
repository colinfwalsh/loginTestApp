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
    var loginButton: LoginButton {
        let login = LoginButton(readPermissions: [ .publicProfile ])
        login.center = view.center
        view.addSubview(login)
        return login
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.delegate = self
        
        if let _ = FBSDKAccessToken.current(){
            getFBUserData()
        }
        
        //adding it to view
        
        
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
        print("Sorry to see you go! You are logged out.")
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if (FBSDKAccessToken.current() != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) in
                
                // If we get an error, print it and then break out of the function
                if let error = error {
                    print(error)
                    return
                }
                
                // Check to make sure result is not nil, if it is break out
                guard let resultData = result else {return}
                
                // Print it to see what we get back
                print(resultData)
                
                // Attempt to cast the result as a dictionary of <Key: String, Value: AnyObject> else break out of the function
                guard let returnDict = resultData as? [String: AnyObject] else {return}
                
                // Last check to make sure the cast was successful
                print(returnDict)
                
                // We set our property at the top to returnDict
                self.dict = returnDict
                
            })
            
            /*
             
             Original tutorial did this, DO NOT HANDLE DATA THIS WAY
                .start(completionHandler: { (connection, result, error) -> Void in
                
                The thinking here was to check to see if the error existed, if it did not
                then they went ahead and did the forced cast of the result to a dictionary
                and set it to our property at the top.  This can fail in a number of ways, and
                is pretty dangerous.  While this probably will work 99% of the time (since we know that the data will largely
                remain consistent from Facebook) it's better to have checks to make sure the app does not crash or have undefined
                behavior.
             
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
             
            })*/
        }
    }

}

