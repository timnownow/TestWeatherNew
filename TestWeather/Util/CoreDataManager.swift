//
//  CoreDataManager.swift
//  TestWeather
//
//  Created by Tim on 07.06.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import CoreData
import Foundation

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    private init () {}
    
    func deleteAllPages()
    {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pages")
        fetch.includesPropertyValues = false
        
        do {
            var i=0
            let searchResults = try persistentContainer.viewContext.fetch(fetch)  as! [NSManagedObject]
            
            for item in searchResults  {
                persistentContainer.viewContext.delete(item)
                i += 1
                print("удален: \(i) item")
            }
            
            saveContext()
            
        } catch {
            print("error in deleteAllEvents : \(error)")
        }
        
    }
    
    func deletePage(city_id:Int)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pages")
        let predicate = NSPredicate(format: "id_city == \(city_id)")
        fetchRequest.predicate = predicate

        do {
            var i=0
            let searchResults = try persistentContainer.viewContext.fetch(fetchRequest)  as! [NSManagedObject]
            
            for item in searchResults  {
                persistentContainer.viewContext.delete(item)
                i += 1
                print("удален: \(i) item")
            }
            
            saveContext()
            
        } catch {
            print("error in deleteAllEvents : \(error)")
        }
        
    }
    
    func getPages() -> [Page]
    {
        var pages = [Page]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pages")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let searchResults = try persistentContainer.viewContext.fetch(fetchRequest)

            for page in searchResults as! [Pages] {
                pages.append(Page(city_id: Int(page.id_city), city_name: page.name!))
            }
        } catch {
            print("Error with request: \(error)")
        }
        return pages
    }
    
    func addPage(item: CityFind)
    {
        if !isHavePage(id: item.city_id)
        {
            let page = Pages(context: persistentContainer.viewContext)
            page.id_city =   Int32(item.city_id)
            page.name = item.city_name
            saveContext()
        }
    }
    
    func isHavePage(id:Int) -> Bool
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pages")
        let predicate = NSPredicate(format: "id_city == \(id)")
        fetchRequest.predicate = predicate
        
        do {
            let searchResults = try persistentContainer.viewContext.fetch(fetchRequest)
            print ("num of results = \(searchResults.count)")
            
            if searchResults.count == 0
            {
                return false
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        return true
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TestWeather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}
