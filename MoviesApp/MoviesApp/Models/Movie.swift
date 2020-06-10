//
//  Movie.swift
//  MoviesApp
//
//  Created by santi on 02/05/20.
//  Copyright © 2020 santi. All rights reserved.
//

import SwiftUI

struct PopularModel : Codable {
    var results : [MovieModel]//El nombre de esta variable tambien debe coincidir con el nombre que sale en la api
    
    
}


struct MovieModel : Codable,Identifiable {
    var popularity : Float
    var vote_count : Int32
    var video : Bool
    var poster_path : String?
    var id : Int32
    var adult : Bool
    var backdrop_path : String?
    var original_language : String
    var original_title : String
    var title : String
    var vote_average : Float
    var overview : String
    var release_date : String
}
