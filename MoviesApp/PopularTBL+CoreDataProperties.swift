//
//  PopularTBL+CoreDataProperties.swift
//  MoviesApp
//
//  Created by santi on 15/05/20.
//  Copyright © 2020 santi. All rights reserved.
//
//

import Foundation
import CoreData


extension PopularTBL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PopularTBL> {
        return NSFetchRequest<PopularTBL>(entityName: "PopularTBL")
    }

    @NSManaged public var id: Int32
    @NSManaged public var original_languaje: String
    @NSManaged public var original_title: String
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Float
    @NSManaged public var poster_path: String?
    @NSManaged public var release_date: String
    @NSManaged public var title: String
    @NSManaged public var video: Bool
    @NSManaged public var vote_average: Float
    @NSManaged public var vote_count: Int32
    @NSManaged public var backdrop_path: String?
    @NSManaged public var adult: Bool

}
