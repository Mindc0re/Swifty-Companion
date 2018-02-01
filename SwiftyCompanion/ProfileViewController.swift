//
//  ProfileViewController.swift
//  SwiftyCompanion
//
//  Created by Simon GAUDIN on 2/1/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.title = "Profile"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parent = self.parent as! TabBarViewController
        
        guard let user = parent.selectedUser else { showAlert(); return }
        if user.isEmpty {
            self.showAlert()
            return
        }
        apiController.getUserByName(login: user) { (jsonObj) in
            if let json = jsonObj {
                self.setupUser(json: json)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAlert()
    {
        let alert = UIAlertController(title: "Error", message: "User not found", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupUser(json: JSON)
    {
        let parent = self.parent as! TabBarViewController

        apiController.getCoalition(login: parent.selectedUser!) { (coalition) in
            if let coa = coalition {
                parent.user = User(displayName: json["displayname"].stringValue, phone: json["phone"].stringValue, img_url: json["image_url"].stringValue, level: json["cursus_users"][0]["level"].floatValue, location: json["location"].stringValue, coalition: coa)
            }
            DispatchQueue.main.async {
                self.setupView()
            }
        }
    }
    
    func setupView()
    {
        let parent = self.parent as! TabBarViewController
        
        self.recupImage(urlImage: parent.user?.img_url)
        self.displayName.text = parent.user?.displayName
        self.location.text = parent.user?.location
        self.phoneNumber.text = parent.user?.phone
        guard let lvl = parent.user?.level else { return }
        self.level.text = String(format: "%.2f", lvl)
        
        var backgroundImage = UIImageView(image: UIImage(named: "background_42"))
        
        if let coa = parent.user?.coalition {
            backgroundImage = UIImageView(image: UIImage(named: "\(coa)"))
        }
        
        self.view.addSubview(backgroundImage)
        self.view.sendSubview(toBack: backgroundImage)
    }
    
    func recupImage(urlImage: String?)
    {
        guard let urlStr = urlImage else { return }
        let session = URLSession(configuration: .default)
        let url = URL(string: urlStr)
        let task = session.dataTask(with: url!) { (data, response, error) in
            if let e = error { print("Image error : \(e)"); return }
            else if let _ = response {
                if let d = data {
                    DispatchQueue.main.async {
                        self.userImg.image = UIImage(data: d)
//                        self.userImg.layer.cornerRadius = self.userImg.frame.size.width / 2
//                        self.userImg.clipsToBounds = true
                    }
                }
                else { print("Image error"); return }
            }
            else { print("Image error"); return }
        }
        
        task.resume()
    }
    
}
