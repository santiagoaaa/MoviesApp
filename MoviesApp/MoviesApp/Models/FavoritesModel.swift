//
//  FavoritesModel.swift
//  MoviesApp
//
//  Created by santi on 13/05/20.
//  Copyright © 2020 santi. All rights reserved.
//

import SwiftUI

struct FavoritesModel: Decodable {
    var items : [MovieModel]
}


struct MovieFavoriteModel : Codable,Identifiable {
    var poster_path : String?
    var id : Int32
    var backdrop_path : String?
    var title : String
    var overview : String
}
