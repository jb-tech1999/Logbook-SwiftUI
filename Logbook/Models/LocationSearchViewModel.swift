//
//  LocationSearchViewModel.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/07.
//

import Foundation
import MapKit
import Combine

class LocationViewModel: ObservableObject {
    
    func forwardGeocoding(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print("Failed to retrieve location")
                return
            }
            
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                print("\nlat: \(coordinate.latitude), long: \(coordinate.longitude)")
            }
            else
            {
                print("No Matching Location Found")
            }
        })
    }
}
