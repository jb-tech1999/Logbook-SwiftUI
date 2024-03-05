//
//  CarViewModel.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/05.
//

import Foundation

class CarListViewModel: ObservableObject {
    @Published var cars : [carViewModel] = []
    
    @Published var isShowingAddCarView = false
    
    func showAddCar() {
        isShowingAddCarView = true
    }
    
    func getAllCars() {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "authtoken") else {
            return
        }
        
        Webservice().getCars(token: token) {(result) in
            switch result {
                case .success(let cars):
                DispatchQueue.main.async {
                    self.cars = cars.map(carViewModel.init)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func deleteCar(car: carViewModel) {
        
        if let index = cars.firstIndex(of: car) {
            cars.remove(at: index)
        }
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "authtoken") else {
            return
        }
        
        Webservice().deleteCar(token: token, registration: car.registration) {(result) in
            switch result {
            case .success(let message):
                print("Deleted")
            case .failure(let error):
                print(error.localizedDescription)
            }
        
        }
        
    }
}




struct carViewModel: Hashable, Identifiable {
    let car: Car
    let id = UUID()

    var model: String {
        return car.model
    }

    var make: String {
        return car.make
    }

    var registration: String {
        return car.registration
    }

    func hash(into hasher: inout Hasher) {
        // Use any of the properties that uniquely identify your instance
        hasher.combine(id)
    }
}
extension carViewModel: Equatable {
    static func == (lhs: carViewModel, rhs: carViewModel) -> Bool {
        // Compare using the registration property
        return lhs.registration == rhs.registration
    }
}

