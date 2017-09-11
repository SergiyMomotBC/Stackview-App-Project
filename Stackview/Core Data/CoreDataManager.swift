//
//  CoreDataManager.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/29/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private var persistentContainer: NSPersistentContainer
    
    private init() {
        self.persistentContainer = NSPersistentContainer(name: "Stackview")
        self.persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    private var managedContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
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
        return (try? managedContext.fetch(fetchRequest)) ?? []
    }
}

