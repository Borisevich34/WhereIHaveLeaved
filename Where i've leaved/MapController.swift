//
//  MapController.swift
//  Where i've leaved
//
//  Created by Pavel Borisevich on 20.10.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {
    

    var card: Card!
    let geoCoder = CLGeocoder()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func pressedBack(_ sender: AnyObject) {
        geoCoder.cancelGeocode()
         _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        geoCoder.geocodeAddressString(card.location, completionHandler: { [unowned self] placemarks, error in
            if error != nil {
                print(error)
            }
            else {
                
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = self.card.landlord
                    annotation.subtitle = self.card.monthlyRent
                    
                    if let location = placemark.location {
                        annotation.coordinate = location.coordinate
                        
                        self.mapView.showAnnotations([annotation], animated: true)
                        self.mapView.selectAnnotation(annotation, animated: true)
                    }
                }
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print()
        print("Goodbay, MapController")
        print()
    }
    
}
