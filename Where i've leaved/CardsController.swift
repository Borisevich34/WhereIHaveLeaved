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
    
    func deleteCard(index: Int)
    func editCard(index: Int, card: Card)
}

class CardsController: UITableViewController, CardDelegate {
    
    var cards = [Card]()
    
    var formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter
    }()

    @IBAction func addNewCard(_ sender: UIBarButtonItem) {
        
        let card = Card()
        
        card.date = Date()
        card.isCurrent = false
        card.landlord = "Landlord"
        card.location = "Location"
        card.monthlyRent = "0.0"
        
        CoreDataForCards.shared.addCard(card)
        cards.insert(card, at: 0)
        tableView.reloadData()
    }
    
    func deleteCard(index: Int) {
        
        CoreDataForCards.shared.deleteCard(with: cards[index].storeId)
        
        cards.remove(at: index)
        tableView.reloadData()

    }
    
    func editCard(index: Int, card: Card) {
        
        CoreDataForCards.shared.deleteCard(with: card.storeId)
        cards.remove(at: index)
        
        CoreDataForCards.shared.addCard(card)
        cards.insert(card, at: 0)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        if let cardsFromCoreData = CoreDataForCards.shared.getCards() {
            cards = cardsFromCoreData
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
            cell.monthlyRent.text = "\(cards[indexPath.row].monthlyRent) $"
           
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

        if segue.identifier == "Edit", let sender = sender as? UIView , let index = (indexPathForViewInCell(sender: sender)?.row), let editController = segue.destination as? EditController {

            editController.cellIndex = index
            editController.card = cards[index]
            editController.delegate = self
            
        }
        
    }


}
