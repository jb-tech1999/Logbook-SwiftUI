//
//  AddLogView.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/06.
//

import Foundation


class addLogViewModel: ObservableObject {
    @Published var newlog : [newLogViewModel] = []
    var carRegistration: String = ""
    var date: Date = .now
    var odometer: Int = 0
    var distance: Double = 0.0
    var totalcost: Double = 0.0
    var garage: String = ""
    var litersPurchase: Double = 0.0
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short // You can customize the date style based on your needs
        return dateFormatter.string(from: date)
    }
    
    func saveLog() {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "authtoken") else {
            return
        }
        
        Webservice().addLog(token: token, carRegistration: carRegistration, date: formatDate(date), odometer: odometer, distance: distance, totalcost: totalcost, garage: garage, litersPurchase: litersPurchase) {result in
            switch result {
            case .success(let newlog):
                DispatchQueue.main.async {
                    self.newlog = newlog.map(newLogViewModel.init)
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
