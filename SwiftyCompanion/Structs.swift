//
//  User.swift
//  SwiftyCompanion
//
//  Created by Simon GAUDIN on 2/1/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

enum COALITION: Int
{
    case FEDERATION = 1
    case ALLIANCE = 2
    case ASSEMBLY = 3
    case ORDER = 4
}

struct User
{
    var displayName: String
    var phone: String
    var img_url: String
    var level: Float
    var location: String
    var coalition: COALITION?
}

struct Skill
{
    var title: String
    var level: Float

    init(json: JSON) {
        self.title = json["name"].stringValue
        self.level = json["level"].floatValue
    }
}

struct Project
{
    var name: String
    var status: String
    var statusImg: UIImage
    var finalMark: Int
    
    init(json: JSON) {
        if json["project"]["name"].stringValue.contains("Day ") || json["project"]["name"].stringValue.contains("Rush ") || json["project"]["parent_id"].stringValue != "null"
        {
            self.name = json["project"]["slug"].stringValue
        }
        else
        {
            self.name = json["project"]["name"].stringValue
        }
        self.status = json["status"].stringValue
        self.finalMark = json["final_mark"].intValue
        switch json["validated?"].stringValue {
        case "null":
            self.statusImg = UIImage(named: "pending")!
            break
        case "true":
            self.statusImg = UIImage(named: "valid")!
            break
        case "false":
            self.statusImg = UIImage(named: "nonValid")!
            break
        default:
            self.statusImg = UIImage(named: "pending")!
            break
        }
    }
}

