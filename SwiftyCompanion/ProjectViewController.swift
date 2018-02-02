//
//  ProjectViewController.swift
//  SwiftyCompanion
//
//  Created by Simon GAUDIN on 2/2/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var projects: [Project]? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.title = "Projects"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let parent = self.parent as! TabBarViewController
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background_42")
        backgroundImage.contentMode = .scaleAspectFill
        if let coa = parent.user?.coalition {
            backgroundImage.image = UIImage(named: "\(coa)")
        }
        self.view.addSubview(backgroundImage)
        self.view.sendSubview(toBack: backgroundImage)
        
        guard let userJson = parent.userJson else { return }
        if userJson.isEmpty { return }
        
        self.setupView(user: userJson)
        self.setupProjects(user: userJson)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupView(user: JSON)
    {
        self.tableView.backgroundColor = UIColor.clear
        
        let parent = self.parent as! TabBarViewController
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background_42")
        backgroundImage.contentMode = .scaleAspectFill
        if let coa = parent.user?.coalition {
            backgroundImage.image = UIImage(named: "\(coa)")
        }
        self.view.addSubview(backgroundImage)
        self.view.sendSubview(toBack: backgroundImage)
    }
    
    func setupProjects(user: JSON)
    {
        self.projects = (user["projects_users"].array)!.map({ Project(json: $0) })
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let projects = self.projects else { return 0 }
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectTableViewCell
        cell.project = self.projects?[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
    
}
