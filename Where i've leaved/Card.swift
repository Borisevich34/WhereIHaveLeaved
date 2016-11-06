//
//  Card.swift
//  Where i've leaved
//
//  Created by Pavel Borisevich on 19.10.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit
import CoreData

class Card {
    
    var location : String = ""
    var landlord : String = ""
    var monthlyRent : String = ""
    
    var isCurrent : Bool = false
    var storeId : NSManagedObjectID = NSManagedObjectID()
    
    var date = Date()
}
