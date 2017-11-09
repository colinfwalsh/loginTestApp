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
    
  
    @IBAction func dismissView(_ sender: Any) {
        self.dismissalDelegate?.finishedShowing(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.name.text = dataDict["name"] as? String
        self.profilePic.layer.cornerRadius =
            profilePic.frame.size.width/2
        
        profilePic.clipsToBounds = true
        
        guard let pictureDict = dataDict["picture"] else {return}
        
        //print(pictureDict)
        
        guard let dataDict = pictureDict["data"] as? [String : Any] else {return}
        
        //print(dataDict)
        
        guard let urlItem = dataDict["url"] else {return}
        
        guard let urlString = urlItem as? String else {return}
        
        let url = URL(string: urlString)
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: url!) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        
                        OperationQueue.main.addOperation {
                            
                            self.profilePic.image = image
                        }
                        
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
        
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
