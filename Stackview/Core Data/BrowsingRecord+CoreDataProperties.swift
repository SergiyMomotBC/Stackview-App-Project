//
//  BrowsingRecord+CoreDataProperties.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/28/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//
//

import Foundation
import CoreData

extension BrowsingRecord {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BrowsingRecord> {
        return NSFetchRequest<BrowsingRecord>(entityName: "BrowsingRecord")
    }

    @NSManaged public var title: String?
    @NSManaged public var tagsData: NSData?
    @NSManaged public var viewedDate: NSDate?
    @NSManaged public var questionID: Int64
}
