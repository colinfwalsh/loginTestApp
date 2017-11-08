//
//  ProfileViewController.swift
//  loginTestApp
//
//  Created by Colin Walsh on 11/8/17.
//  Copyright © 2017 Colin Walsh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, Dismissable {
    var dismissalDelegate: DismissalDelegate?

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    var dataDict: [String: AnyObject]!
    
    static func makeProfileViewController(dictionary: [String: AnyObject]) -> ProfileViewController {
        
        let newVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        
        newVC.dataDict = dictionary
        
        return newVC
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissalDelegate?.finishedShowing(self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
