//
//  ProfileViewController.swift
//  SwiftyCompanion
//
//  Created by Simon GAUDIN on 2/1/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var levelProgress: UIProgressView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cursusPicker: UIPickerView!
    
    var pickerData: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.title = "Profile"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cursusPicker.delegate = self
        self.cursusPicker.dataSource = self

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background_42")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        self.view.sendSubview(toBack: backgroundImage)
        
        let parent = self.parent as! TabBarViewController
        
        deactivateInterface(true)
        self.activityIndicator.startAnimating()
        
        guard let user = parent.selectedUser else { showAlert(); return }
        if user.isEmpty {
            self.showAlert()
            return
        }
        apiController.getUserByName(login: user) { (jsonObj) in
            if let json = jsonObj {
                if json.isEmpty {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                    self.showAlert()
                    return
                }
                parent.userJson = json
                self.setupUser(json: json)
                self.deactivateInterface(false)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    backgroundImage.isHidden = true
                }
            }
            else {
                self.showAlert();
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerData[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = self.pickerData[row]
        let strCustom = NSAttributedString(string: str, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return strCustom
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let parent = self.parent as! TabBarViewController
        if let userJson = parent.userJson {
            let level = userJson["cursus_users"][row]["level"].floatValue
            self.level.text = String(format: "%.2f", level)
            let lvlDecimal = String(level).split(separator: ".")
            if lvlDecimal.count == 2
            {
                self.levelProgress.progress = Float(lvlDecimal[1])! / 100
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            self.userImg.layer.cornerRadius = 50
        }
        else {
            self.userImg.layer.cornerRadius = 62.5
        }
    }
    
    func deactivateInterface(_ disabled: Bool)
    {
        DispatchQueue.main.async {
            self.userImg.isHidden = disabled
            self.displayName.isHidden = disabled
            self.location.isHidden = disabled
            self.level.isHidden = disabled
            self.phoneNumber.isHidden = disabled
            self.levelProgress.isHidden = disabled
            self.cursusPicker.isHidden = disabled
        }
    }
    
    func showAlert()
    {
        let alert = UIAlertController(title: "Error", message: "User not found", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
        self.activityIndicator.stopAnimating()
    }
    
    func setupUser(json: JSON)
    {
        let parent = self.parent as! TabBarViewController

        apiController.getCoalition(login: parent.selectedUser!) { (coalition) in
            if let coa = coalition {
                parent.user = User(displayName: json["displayname"].stringValue, phone: json["phone"].stringValue, img_url: json["image_url"].stringValue, level: json["cursus_users"][0]["level"].floatValue, location: json["location"].stringValue, coalition: coa)
            }
            else {
                parent.user = User(displayName: json["displayname"].stringValue, phone: json["phone"].stringValue, img_url: json["image_url"].stringValue, level: json["cursus_users"][0]["level"].floatValue, location: json["location"].stringValue, coalition: nil)
            }
            DispatchQueue.main.async {
                self.setupView(json: json)
            }
        }
    }
    
    func setupView(json: JSON)
    {
        let parent = self.parent as! TabBarViewController
        
        self.recupImage(urlImage: parent.user?.img_url)
        self.displayName.text = parent.user?.displayName
        self.location.text = parent.user?.location
        self.phoneNumber.text = parent.user?.phone
        if let lvl = parent.user?.level
        {
            self.level.text = String(format: "%.2f", lvl)
            let lvlDecimal = String(lvl).split(separator: ".")
            if lvlDecimal.count == 2
            {
                self.levelProgress.progress = Float(lvlDecimal[1])! / 100
            }
        }
        
        let cursus_users = json["cursus_users"]
        for cursus in cursus_users
        {
            self.pickerData.append(cursus.1["cursus"]["name"].stringValue)
        }
        self.cursusPicker.reloadAllComponents()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background_42")
        backgroundImage.contentMode = .scaleAspectFill
        if let coa = parent.user?.coalition {
            backgroundImage.image = UIImage(named: "\(coa)")
        }
        self.view.addSubview(backgroundImage)
        self.view.sendSubview(toBack: backgroundImage)
    }
    
    func recupImage(urlImage: String?)
    {
        guard var urlStr = urlImage else { return }
        if urlStr == "https://cdn.intra.42.fr/images/default.png" {
            urlStr = "https://cdn.intra.42.fr/users/medium_default.png"
        }
        let session = URLSession(configuration: .default)
        guard let url = URL(string: urlStr) else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let e = error { print("Image error : \(e)"); return }
            else if let _ = response {
                if let d = data {
                    DispatchQueue.main.async {
                        self.userImg.image = UIImage(data: d)
                        self.userImg.layer.cornerRadius = self.userImg.frame.size.width / 2
                        self.userImg.clipsToBounds = true
                    }
                }
                else { print("Image error"); return }
            }
            else { print("Image error"); return }
        }
        
        task.resume()
    }
    
    
    
}
