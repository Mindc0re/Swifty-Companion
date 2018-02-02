//
//  ProjectTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Simon GAUDIN on 2/2/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var imageAvancement: UIImageView!
    
    @IBOutlet weak var projectName: UILabel!
    
    @IBOutlet weak var projectNote: UILabel!
    
    var project: Project?
    {
        didSet
        {
            if let p = project
            {
                self.imageAvancement.image = p.statusImg
                self.projectName.text = p.name
                self.projectNote.text = String(p.finalMark)
            }
        }
    }
    
}
