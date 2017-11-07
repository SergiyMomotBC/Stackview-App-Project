//
//  CoreDataManager.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/29/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import CoreData

class CoreDataManager {
    private let maxSearchRecords = 6
    private let historyKeepDays = 30
    
    static let shared = CoreDataManager()
    
    private var persistentContainer: NSPersistentContainer
    
    private init() {
        self.persistentContainer = NSPersistentContainer(name: "Stackview")
        self.persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        clearSearchRecords()
        clearOldBrowsingRecords()
    }
    
    private var managedContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func clearSearchRecords() {
        var groupedRecords: [Int16: [SearchRecord]] = [:]
        for record in ((try? managedContext.fetch(SearchRecord.fetchRequest())) ?? []) {
            if groupedRecords[record.type] == nil {
                groupedRecords[record.type] = [record]
            } else {
                groupedRecords[record.type]!.append(record)
            }
        }
        
        for key in groupedRecords.keys {
            groupedRecords[key]!.sort(by: { $0.date as Date > $1.date as Date })
        }
        
        for (_, records) in groupedRecords {
            if records.count > maxSearchRecords {
                for record in records.dropFirst(maxSearchRecords) {
                    managedContext.delete(record)
                }
            }
        }
        
        saveContext()
    }
    
    func clearOldBrowsingRecords() {
        let today = Date()
        
        for record in ((try? managedContext.fetch(BrowsingRecord.fetchRequest())) ?? []) {
            if Calendar.current.dateComponents([.day], from: record.viewedDate! as Date, to: today).day! > historyKeepDays {
                managedContext.delete(record)
            }
        }
        
        saveContext()
    }
    
    func saveContext() {
        if managedContext.hasChanges {
            try? managedContext.save()
        }
    }
    
    func addRecord(title: String, type: SearchRecordType) {
        let record = SearchRecord(entity: SearchRecord.entity(), insertInto: managedContext)
        record.title = title
        record.date = Date() as NSDate
        record.type = type.rawValue
        saveContext()
    }
    
    func deleteRecord(_ record: SearchRecord) {
        managedContext.delete(record)
        saveContext()
    }
    
    func getRecords(of type: SearchRecordType) -> [SearchRecord] {
        let fetchRequest: NSFetchRequest<SearchRecord> = SearchRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == \(type.rawValue)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let results = (try? managedContext.fetch(fetchRequest)) ?? []
        return Array(results.prefix(maxSearchRecords))
    }
    
    func addBrowsingRecord(id: Int, title: String, tags: [String]) {
        let fetchRequest: NSFetchRequest<BrowsingRecord> = BrowsingRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "questionID == \(id)")
        
        if let currentRecord = (try? managedContext.fetch(fetchRequest))?.first {
            managedContext.delete(currentRecord)
        }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let viewedDate = Calendar.current.date(from: dateComponents)
        
        let record = BrowsingRecord(entity: BrowsingRecord.entity(), insertInto: managedContext)
        record.questionID = Int64(id)
        record.title = title
        record.tagsData = NSKeyedArchiver.archivedData(withRootObject: tags) as NSData
        record.viewedDate = viewedDate as NSDate?
        
        saveContext()
    }
    
    func deleteBrowsingRecord(_ record: BrowsingRecord) {
        managedContext.delete(record)
        saveContext()
    }
    
    func getBrowsingRecords(forSearchQuery query: String = "") -> [(date: Date, records: [BrowsingRecord])] {
        let fetchRequest: NSFetchRequest<BrowsingRecord> = BrowsingRecord.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "viewedDate", ascending: false)]
        
        let results = ((try? managedContext.fetch(fetchRequest)) ?? []).filter {
            $0.title!.lowercased().hasPrefix(query.lowercased()) || $0.title!.lowercased().contains(query.lowercased())
        }
        
        var dict: [Date: [BrowsingRecord]] = [:]
        for result in results {
            if dict[result.viewedDate! as Date] != nil {
                dict[result.viewedDate! as Date]!.append(result)
            } else {
                dict[result.viewedDate! as Date] = [result]
            }
        }
        
        for (key, value) in dict {
            dict[key] = value.reversed()
        }
        
        let tuples = dict.map { (date: $0, records: $1) }
        
        return tuples.sorted(by: { $0.0 > $1.0 })
    }
}

