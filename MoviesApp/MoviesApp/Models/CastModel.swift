//
//  CastModel.swift
//  MoviesApp
//
//  Created by santi on 04/05/20.
//  Copyright © 2020 santi. All rights reserved.
//

import SwiftUI

struct CastList: Codable {
    var cast : [CastModel]
    
    /*
     ---EL cast COINCIDE CON LO REGRESA LA API
     {
     "id": 545609,
     "cast": [
       {
         "cast_id": 0,
         "character": "Tyler Rake",
         "credit_id": "5b88a097c3a3682e5000260a",
         "gender": 2,
         "id": 74568,
         "name": "Chris Hemsworth",
         "order": 0,
         "profile_path": "/6fGCcu1bbc0tVCMhQRmeRryGVMa.jpg"
       },
    */
}

struct CastModel: Codable, Identifiable {
    var cast_id : Int
    var character : String
    var credit_id : String
    var gender : Int16
    var id : Int
    var name : String
    var order : Int8
    var profile_path : String?
    
}
