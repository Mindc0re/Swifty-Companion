//
//  SkillTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Simon GAUDIN on 2/1/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

class SkillTableViewCell: UITableViewCell {

    @IBOutlet weak var skillLabel: UILabel!
    
    @IBOutlet weak var skillProgress: UIProgressView!
    
    var skill: Skill?
    {
        didSet
        {
            if let s = skill
            {
                self.skillLabel.text = s.title
                self.skillProgress.progress = s.level
            }
        }
    }
}
