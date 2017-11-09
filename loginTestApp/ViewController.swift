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

protocol DismissalDelegate : class {
    func finishedShowing(_ viewController: UIViewController)
}

protocol Dismissable : class
{
    weak var dismissalDelegate : DismissalDelegate? { get set }
}


class ViewController: UIViewController, LoginButtonDelegate, DismissalDelegate {
    
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
            // https://developers.facebook.com/docs/graph-api/reference/v2.2/page to see all fields
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) in
                
                // If we get an error, print it and then break out of the function
                if let error = error {
                    print(error)
                    return
                }
                
                // Check to make sure result is not nil, if it is break out
                guard let resultData = result else {return}
                
                // Print it to see what we get back
                //print(resultData)
                
                // Attempt to cast the result as a dictionary of <Key: String, Value: AnyObject> else break out of the function
                guard let returnDict = resultData as? [String: AnyObject] else {return}
                
                // Last check to make sure the cast was successful
                print(returnDict)
                
                // We set our property at the top to returnDict
                self.dict = returnDict
                
                // Push to the main thread so we don't lock up the app.  All UI Elements
                // need to be updated on the main thread.
                OperationQueue.main.addOperation {
                    let vc = ProfileViewController.makeProfileViewController(dictionary: self.dict)
                    vc.dismissalDelegate = self
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
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
    } // End of getFBUserData()
    
    // This is the implementation of the delegate method in order to dismiss the ProfileViewController.  Notice how it's defined here, but called in the ProfileVC.  This is a common way of passing data back to the root VC in order to make UI Changes or modify data located at a previous VC.
    
    func finishedShowing(_ viewController: UIViewController) {
        if viewController.isBeingPresented && viewController.presentingViewController == self
        {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}



