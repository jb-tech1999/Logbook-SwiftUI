//
//  AddCarViewModel.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/07.
//

import Foundation

class AddCarViewModel: ObservableObject {
    @Published var isAdded = false
    var model: String = ""
    var year: Int = 2024
    var registration: String = ""
    var make: String = ""
  
    
    func saveCar() {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "authtoken") else {
            return
        }
        Webservice().addCar(token: token, registration: registration, make: make, model: model, year: year) { result in
            switch result {
            case .success(let cars):
                print(cars)
                        DispatchQueue.main.async {
                            self.isAdded = true
                        }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
    }
    
}


