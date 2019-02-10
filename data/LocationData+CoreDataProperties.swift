//
//  LocationData+CoreDataProperties.swift
//  WeatherDemo
//
//  Created by mohamed on 2/9/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//
//

import Foundation
import CoreData


extension LocationData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationData> {
        return NSFetchRequest<LocationData>(entityName: "LocationData")
    }

    @NSManaged public var location: String?

}
