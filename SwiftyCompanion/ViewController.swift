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

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: SearchTextField!
    
    var apiController: APIController = APIController()
    
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
            }
        }
        
        searchTextField.theme = SearchTextFieldTheme.lightTheme()
        searchTextField.highlightAttributes = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 15)]
        searchTextField.theme.font = UIFont.systemFont(ofSize: 15)
        searchTextField.minimumFontSize = UIFont.systemFontSize
        searchTextField.comparisonOptions = [.caseInsensitive]
        searchTextField.maxNumberOfResults = 5
        searchTextField.maxResultsListHeight = 160
        searchTextField.itemSelectionHandler = { item, itemPosition in
            // CODE REQUETE HERE
        }
//        searchTextField.filterStrings(["coucou", "lol", "mdr"])
        
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
    
    
}

