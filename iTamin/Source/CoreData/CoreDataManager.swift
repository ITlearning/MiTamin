//
//  CoreDataManager.swift
//  iTamin
//
//  Created by Tabber on 2022/10/15.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistenContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iTamin")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistenContainer.viewContext
    }
    
    func loadEntity(name: String) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: name, in: context)
    }
    
    func saveToContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func insertStatus(status: MyTaminProgressModel) {
        if let entity = loadEntity(name: "MyTaminStatus") {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(status.careIsDone, forKey: "careIsDone")
            managedObject.setValue(status.reportIsDone, forKey: "reportIsDone")
            managedObject.setValue(status.breathIsDone, forKey: "breathIsDone")
            managedObject.setValue(status.senseIsDone, forKey: "senseIsDone")
            saveToContext()
        }
    }
    
    func fetchStatus() -> [MyTaminStatus] {
        do {
            let request = MyTaminStatus.fetchRequest()
            let result = try context.fetch(request)
            return result
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
}
