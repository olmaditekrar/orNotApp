//
//  cellModel.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 6.02.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import Foundation

struct cell {
    public var post : String
    public var positiveStatus : String
    public var negativeStatus : String
    init(post : String,positiveStatus : String,negativeStatus : String) {
        self.post = post
        self.positiveStatus = positiveStatus
        self.negativeStatus = negativeStatus
    }
}
