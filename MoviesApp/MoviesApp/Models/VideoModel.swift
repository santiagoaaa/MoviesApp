//
//  VideoModel.swift
//  MoviesApp
//
//  Created by santi on 04/05/20.
//  Copyright © 2020 santi. All rights reserved.
//

import SwiftUI

struct VideoList : Codable {
    var results : [VideoModel]
}

struct VideoModel: Codable, Identifiable {
    var id : String
    var key : String
    var name : String
    var site : String
    var size : Int16
    var type : String
    
}
