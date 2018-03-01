//
//  Data.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 6.02.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import Foundation
class Data {
    static let instance = Data()
    
    private let posts = [
        cell(post: "ali ata bak", positiveStatus: "güzel", negativeStatus: "kötü"),
        cell(post: "ali ata bak", positiveStatus: "güzel", negativeStatus: "kötü"),
        cell(post: "ali ata bak", positiveStatus: "güzel", negativeStatus: "kötü"),
        cell(post: "ali ata bak", positiveStatus: "güzel", negativeStatus: "kötü")

    ]
    func getPosts() -> [cell] {
        return posts
    }
}
