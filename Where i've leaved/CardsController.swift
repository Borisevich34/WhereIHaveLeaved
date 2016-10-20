//
//  TableViewController.swift
//  Where i've leaved
//
//  Created by Pavel Borisevich on 19.10.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit
import CoreData

protocol CardDelegate {
    func addNewCard(card: Card)
    func deleteCard(index: Int)
    func editCard(index: Int, card: Card)
}

class CardsController: UITableViewController, CardDelegate {
    
    var cards = [Card]()
    
    var formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E yyyy-MM-dd"
        return formatter
    }()

    
    func addNewCard(card: Card) {
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let coreCard = NSEntityDescription.insertNewObject(forEntityName: "Card", into: context)
            
            coreCard.setValue(card.date, forKey: "date")
            coreCard.setValue(card.isCurrent, forKey: "isCurrent")
            coreCard.setValue(card.isFromEdit, forKey: "isFromEdit")
            coreCard.setValue(card.landlord, forKey: "landlord")
            coreCard.setValue(card.location, forKey: "location")
            coreCard.setValue(card.monthlyRent, forKey: "monthlyRent")
            
            try context.save()
            
            cards.insert(card, at: 0)
            tableView.reloadData()
        }
        catch {
            print("CoreData error!!!")
        }
    }
    
    func deleteCard(index: Int) {
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
            request.returnsObjectsAsFaults = false
            
            let results = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(request)
            
            context.delete(results[cards.count - index - 1] as! NSManagedObject)
            
            try context.save()
            
            cards.remove(at: index)
            tableView.reloadData()
        }
        catch {
            print("CoreData error!!!")
        }

    }
    
    func editCard(index: Int, card: Card) {
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
            request.returnsObjectsAsFaults = false
            let results = try appDelegate.persistentContainer.viewContext.fetch(request)
            context.delete(results[cards.count - index - 1] as! NSManagedObject)
            try context.save()
            cards.remove(at: index)
            
            let coreCard = NSEntityDescription.insertNewObject(forEntityName: "Card", into: context)
            coreCard.setValue(card.date, forKey: "date")
            coreCard.setValue(card.isCurrent, forKey: "isCurrent")
            coreCard.setValue(card.isFromEdit, forKey: "isFromEdit")
            coreCard.setValue(card.landlord, forKey: "landlord")
            coreCard.setValue(card.location, forKey: "location")
            coreCard.setValue(card.monthlyRent, forKey: "monthlyRent")
            try context.save()
            cards.insert(card, at: 0)
            
            tableView.reloadData()
        }
        catch {
            print("CoreData error!!!")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
            request.returnsObjectsAsFaults = false
            
            let results = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(request)
        
            for result in results as! [NSManagedObject] {
                let card = Card()
                
                card.date = (result.value(forKey: "date") as? Date) ?? Date()
                card.isCurrent = (result.value(forKey: "isCurrent") as? Bool) ?? false
                card.isFromEdit = (result.value(forKey: "isFromEdit") as? Bool) ?? true
                card.landlord = (result.value(forKey: "landlord") as? String) ?? ""
                card.location = (result.value(forKey: "location") as? String) ?? ""
                card.monthlyRent = (result.value(forKey: "monthlyRent") as? String) ?? ""

                cards.insert(card, at: 0)
            }
            print("Count = \(results.count)")
        }
        catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "Card")! as? CardCell {
            
            cell.location.text = cards[indexPath.row].location
            cell.landlord.text = cards[indexPath.row].landlord
            cell.monthlyRent.text = cards[indexPath.row].monthlyRent
           
            cell.date.text = formatter.string(from: cards[indexPath.row].date)
            
            if cards[indexPath.row].isCurrent == false {
                cell.currentImage.alpha = 0
            }
            else {
                cell.currentImage.alpha = 1
            }
            
            return cell
        }
        else {
            return UITableViewCell()
        }
        
    }
    
    func indexPathForViewInCell(sender: UIView) -> IndexPath? {
        let point = sender.convert(CGPoint.zero, to: self.tableView)
        return self.tableView.indexPathForRow(at: point) as IndexPath?
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let editController = segue.destination as? EditController {
            editController.delegate = self
        }
        else {
            if let cell = sender as? CardCell, let mapController = segue.destination as? MapController, let index = tableView.indexPath(for: cell)?.row {
                mapController.card = cards[index]
            }

        }
        
        if segue.identifier == "Edit", let sender = sender as? UIView , let index = (indexPathForViewInCell(sender: sender)?.row), let editController = segue.destination as? EditController {

            editController.cellIndex = index
            editController.card = cards[index]
            
        }
        
    }


}
