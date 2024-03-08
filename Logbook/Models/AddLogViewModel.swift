//
//  AddLogViewModel.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/06.
//

import Foundation


class addLogViewModel: ObservableObject {
    
    
    @Published var isAdded = false
    @Published var carRegistration: String?
    var date: Date = .now
    var odometer: Int?
    var distance: Double?
    var totalcost: Double?
    var garage: String = ""
    var litersPurchase: Double?
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

    // Helper function to parse String to Date
    func dateFromString(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString) ?? Date()
    }

        
        func saveLog() {
            let defaults = UserDefaults.standard
            guard let token = defaults.string(forKey: "authtoken") else {
                return
            }
            
            Webservice().addLog(token: token, carRegistration: carRegistration ?? "", date: formattedDate(date), odometer: odometer ?? 0, distance: distance ?? 0, totalcost: totalcost ?? 0, garage: garage, litersPurchase: litersPurchase ?? 0) {result in
                switch result {
                case .success(let message):
                    print(message)
                    
                    DispatchQueue.main.async {
                        self.isAdded = true
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            }
        }
        
        struct newLogViewModel {
            let log: LogResponse
            
            init(log: LogResponse) {
                self.log = log
            }
            
            var formattedDate: String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the format based on your date string
                if let date = dateFormatter.date(from: log.date) {
                    dateFormatter.dateStyle = .medium
                    return dateFormatter.string(from: date)
                } else {
                    return "Invalid Date"
                }
            }
            
            var formattedDistance: String {
                return String(format: "%.2f km", log.distance)
            }
            
            var formattedLitersPurchase: String {
                return String(format: "%.2f L", log.litersPurchase)
            }
            
            var formattedTotalCost: String {
                return String(format: "R%.2f", log.totalcost)
            }
        }
        
    
