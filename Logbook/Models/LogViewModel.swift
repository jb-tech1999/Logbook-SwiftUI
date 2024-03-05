//
//  LogViewModel.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/06.
//

import Foundation

class LogListViewModel: ObservableObject {
    @Published var logs : [LogViewModel] = []
    @Published var isShowingAddLogView = false
    
    func showAddLog() {
        isShowingAddLogView = true
    }
    
    func GetLogs(registration: String) {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "authtoken") else {
            return
        }
        
        Webservice().getLogs(token: token, registration: registration ) {(result) in
            switch result {
                case .success(let logs):
                DispatchQueue.main.async {
                    self.logs = logs.map(LogViewModel.init)
                }
            case .failure(let error):

                print(error.localizedDescription)
            }
        }
    }
}

    

struct LogViewModel {
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
