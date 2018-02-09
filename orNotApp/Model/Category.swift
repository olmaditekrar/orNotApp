//
//  Category.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 6.02.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import Foundation
struct Category {
    public var negativeStatus: String
    public var positiveStatus: String
    public  var colone2name: String
    public  var colone1bame: String
    public  var negativeButtonname: String
    public  var positiveButtonname: String
    public  var post: String
    
    init(negativeStatus : String,positiveStatus: String,colone2name: String,colone1bame: String,negativeButtonname: String,positiveButtonname: String,post: String) {
        self.negativeStatus = negativeStatus
        self.positiveStatus = positiveStatus
        self.colone2name = colone2name
        self.colone1bame = colone1bame
        self.negativeButtonname = negativeButtonname
        self.positiveButtonname = positiveButtonname
        self.post = post
    }
    
}
