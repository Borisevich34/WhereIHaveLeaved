//
//  CoreData.swift
//  Where i've leaved
//
//  Created by Pavel Borisevich on 06.11.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import CoreData

class CoreDataForCards {

    static let shared = CoreDataForCards()
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Where_i_ve_leaved")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

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
    
    func deleteCard( with id : NSManagedObjectID) {
        
        do {
            
            let context = persistentContainer.viewContext
            
            context.delete(context.object(with: id))
            try context.save()
        }
        catch {
            print("CoreData error!!!")
        }
    }
    
    func addCard(_ card : Card) {
        
        do {
            
            let context = persistentContainer.viewContext
            
            let coreCard = NSEntityDescription.insertNewObject(forEntityName: "Card", into: context)
            
            coreCard.setValue(card.date, forKey: "date")
            coreCard.setValue(card.isCurrent, forKey: "isCurrent")
            coreCard.setValue(card.landlord, forKey: "landlord")
            coreCard.setValue(card.location, forKey: "location")
            coreCard.setValue(card.monthlyRent, forKey: "monthlyRent")
            
            try context.save()
            card.storeId = coreCard.objectID
        }
        catch {
            print("CoreData error!!!")
        }
    }
    
    func getCards() -> [Card]? {
        
        do {
            
            var cards = [Card]()
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
            request.returnsObjectsAsFaults = false
            
            let results = try persistentContainer.viewContext.fetch(request)
            
            for result in results as! [NSManagedObject] {
                let card = Card()
                
                card.date = (result.value(forKey: "date") as? Date) ?? Date()
                card.isCurrent = (result.value(forKey: "isCurrent") as? Bool) ?? false
                card.landlord = (result.value(forKey: "landlord") as? String) ?? ""
                card.location = (result.value(forKey: "location") as? String) ?? ""
                card.monthlyRent = (result.value(forKey: "monthlyRent") as? String) ?? ""
                
                card.storeId = result.objectID
                
                cards.insert(card, at: 0)
                
            }
            
            return cards
        }
        catch {
            
            return nil
        }

    }

}
