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

