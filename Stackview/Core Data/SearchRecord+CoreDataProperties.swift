//
//  SearchRecord+CoreDataProperties.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/29/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//
//

import CoreData

extension SearchRecord {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchRecord> {
        return NSFetchRequest<SearchRecord>(entityName: "SearchRecord")
    }

    @NSManaged public var title: String
    @NSManaged public var date: NSDate
    @NSManaged public var type: Int16
}
