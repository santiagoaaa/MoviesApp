//
//  FavoritesTBL+CoreDataProperties.swift
//  MoviesApp
//
//  Created by santi on 15/05/20.
//  Copyright © 2020 santi. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoritesTBL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritesTBL> {
        return NSFetchRequest<FavoritesTBL>(entityName: "FavoritesTBL")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String
    @NSManaged public var poster_path: String?
    @NSManaged public var backdrop_path: String?
    @NSManaged public var overview: String?

}
