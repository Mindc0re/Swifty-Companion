//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by Simon GAUDIN on 1/29/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit
import SearchTextField
import SwiftyJSON

var apiController: APIController = APIController()
enum COALITION: Int
{
    case FEDERATION = 1
    case ALLIANCE = 2
    case ASSEMBLY = 3
    case ORDER = 4
}

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: SearchTextField!
    @IBOutlet weak var searchButton: UIButton!
    
    //    var selectedUser: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.isEnabled = false
                
        apiController.getAccessToken { (err) in
            if let e = err {
                print(e)
                return
            }
            DispatchQueue.main.async {
                self.searchTextField.isEnabled = true
                print(apiController.accessToken)
            }
        }
        
        searchTextField.theme = SearchTextFieldTheme.lightTheme()
        searchTextField.highlightAttributes = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 15)]
        searchTextField.theme.font = UIFont.systemFont(ofSize: 15)
        searchTextField.minimumFontSize = UIFont.systemFontSize
        searchTextField.comparisonOptions = [.caseInsensitive]
        searchTextField.maxNumberOfResults = 5
        searchTextField.maxResultsListHeight = 160
        
        let backgroundImage = UIImageView(image: UIImage(named: "background_42"))
        self.view.addSubview(backgroundImage)
        self.view.sendSubview(toBack: backgroundImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func updateAutocomplete(_ sender: SearchTextField)
    {
        guard let text = sender.text else { return }
        var users: [String] = []
        apiController.getAllUsers(query: text) { (jsonData) in
            if let json = jsonData
            {
                for i in 0..<json.count
                {
                    if let login = json[i]["login"].string {
                        users.append(login)
                    }
                }
            }
            DispatchQueue.main.async {
                self.searchTextField.maxResultsListHeight = (30 * (users.count)) + 10
                self.searchTextField.filterStrings(users)
            }
        }
    }

//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if identifier == "loginToProfile"
//        {
//            guard let login = self.searchTextField.text else { return false }
//            apiController.getUserByName(login: login, completionHandler: { (jsonOpt) in
//                guard let json = jsonOpt else { return }
//                self.selectedUser = json
//            })
//            if self.selectedUser == nil
//            {
//                let alert = UIAlertController(title: "Error", message: "User not found", preferredStyle: .alert)
//                let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alert.addAction(dismissAction)
//                self.present(alert, animated: true, completion: nil)
//                return false
//            }
//        }
//        return true
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "loginToProfile"
        {
            guard let login = self.searchTextField.text else { return }
            let tabBarVC = segue.destination as! TabBarViewController
            tabBarVC.selectedUser = login
        }
    }
}

