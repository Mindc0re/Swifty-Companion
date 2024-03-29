//
//  SkillsViewController.swift
//  SwiftyCompanion
//
//  Created by Simon GAUDIN on 2/1/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit
import SwiftyJSON

class SkillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var skills: [Skill]? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.title = "Skills"
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
        
        guard let userJson = parent.userJson else { self.segControl.isHidden = true;  return }
        if userJson.isEmpty { self.segControl.isHidden = true;  return }
        
        self.setupView(user: userJson)
        self.setupSkills(user: userJson, cursus: self.segControl.selectedSegmentIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupView(user: JSON)
    {
        self.tableView.backgroundColor = UIColor.clear
        
        let cursus_users = user["cursus_users"]
        self.segControl.removeAllSegments()
        for cursus in cursus_users
        {
            self.segControl.insertSegment(withTitle: cursus.1["cursus"]["name"].stringValue, at: Int(cursus.0)!, animated: false)
        }
        self.segControl.selectedSegmentIndex = 0
    }
    
    func setupSkills(user: JSON, cursus: Int)
    {
        self.skills = (user["cursus_users"][cursus]["skills"].array)!.map({ Skill(json: $0) })
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let skills = self.skills else { return 0 }
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "skillCell") as! SkillTableViewCell
        cell.skill = self.skills?[indexPath.row]
        cell.backgroundColor = .clear
        
        return cell
    }
    
    @IBAction func changedCursus(_ sender: UISegmentedControl)
    {
        let parent = self.parent as! TabBarViewController
        guard let userJson = parent.userJson else { return }
        if userJson.isEmpty { return }
        self.setupSkills(user: userJson, cursus: sender.selectedSegmentIndex)
    }
    
    
}
