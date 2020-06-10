//
//  BuyTBL+CoreDataProperties.swift
//  MoviesApp
//
//  Created by santi on 10/06/20.
//  Copyright © 2020 santi. All rights reserved.
//
//

import Foundation
import CoreData


extension BuyTBL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BuyTBL> {
        return NSFetchRequest<BuyTBL>(entityName: "BuyTBL")
    }

    @NSManaged public var backdrop_path: String?
    @NSManaged public var poster_path: String?
    @NSManaged public var id: Int32
    @NSManaged public var overview: String
    @NSManaged public var title: String

}
