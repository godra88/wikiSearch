//
//  ResultData+CoreDataProperties.swift
//  WikiSearch
//
//  Created by Ivan Fabri on 2/20/20.
//  Copyright © 2020 Ivan Fabri. All rights reserved.
//
//

import Foundation
import CoreData


extension ResultData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ResultData> {
        return NSFetchRequest<ResultData>(entityName: "ResultData")
    }

    @NSManaged public var details: String?
    @NSManaged public var pageid: Int32
    @NSManaged public var snippet: String?
    @NSManaged public var title: String?

}
