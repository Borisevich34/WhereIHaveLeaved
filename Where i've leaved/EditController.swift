//
//  ViewController.swift
//  Where i've leaved
//
//  Created by Pavel Borisevich on 19.10.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit

class EditController: UIViewController {

    var delegate : CardDelegate?
    var card =  Card()
    var cellIndex = 0
    
    var isCurrent : Bool = false

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var landlord: UITextField!
    @IBOutlet weak var monthlyRent: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    
    @IBAction func pressedCancel(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressedSave(_ sender: UIBarButtonItem) {
        
        if let location = location.text, let landlord = landlord.text, let monthlyRent = monthlyRent.text, !location.isEmpty
            && !landlord.isEmpty && !monthlyRent.isEmpty {
                
            
            card.location = location
            card.landlord = landlord
            card.monthlyRent = monthlyRent
            card.isCurrent = isCurrent
            card.date = datePicker.date
            
            if card.isFromEdit == false {
                card.isFromEdit = true
                
                delegate?.addNewCard(card: card)
            }
            else {
                
                delegate?.editCard(index: cellIndex, card: card)
            }
            
            let alertController = UIAlertController(title: "Successful", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){ [unowned self] action in _ = self.navigationController?.popViewController(animated: true)})
            present(alertController, animated: true, completion: nil)
            
        }
        else {
            
            let alertController = UIAlertController(title: "Sorry", message: "Fill empty fields", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func deleteCard(_ sender: UIBarButtonItem) {
        
        delegate?.deleteCard(index: cellIndex)
    
        let alertController = UIAlertController(title: "Successful", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){ [unowned self] action in _ = self.navigationController?.popViewController(animated: true)})
        present(alertController, animated: true, completion: nil)
    
    }
    
    @IBAction func selectCurrent(_ sender: UIButton) {
        if isCurrent {
            isCurrent = false
            currentImage.alpha = 0
        }
        else {
            isCurrent = true
            currentImage.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location.text = card.location
        landlord.text = card.landlord
        monthlyRent.text = card.monthlyRent
        if !card.isCurrent {
            currentImage.alpha = 0
        }
        datePicker.date = card.date
        isCurrent = card.isCurrent
        deleteButton.isEnabled = card.isFromEdit
        
    }
    
    @IBAction func locationDonePressed(_ sender: AnyObject) {
    }
    @IBAction func landlordDonePressed(_ sender: AnyObject) {
    }
    @IBAction func monthlyRentDonePressed(_ sender: AnyObject) {
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    deinit {
        print()
        print("Goodbay, EditController")
        print()
    }
    
}
