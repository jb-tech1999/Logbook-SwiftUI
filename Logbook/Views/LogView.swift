//
//  LogView.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/05.
//

import SwiftUI

struct LogView: View {
    
    @ObservedObject private var  viewModel: AuthViewModel = AuthViewModel()
    @ObservedObject var  logListVM = LogListViewModel()
    
    var sortedLogs: [LogViewModel] {
        return logListVM.logs.sorted { log1, log2 in
            // Assuming log.date is a string and formatted as "yyyy-MM-dd HH:mm:ss"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date1 = dateFormatter.date(from: log1.log.date),
               let date2 = dateFormatter.date(from: log2.log.date) {
                return date1 > date2
            }
            return false
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                if sortedLogs.count > 0 {
                    List {
                        ForEach(sortedLogs, id: \.log.logid) { logViewModel in
                            NavigationLink (destination: LogDetailView(logViewModel: logViewModel)) {
                                HStack {
                                    Text("\(logViewModel.formattedDate)")
                                    Spacer()
                                    Text("TotalCost: \(logViewModel.formattedTotalCost)")
                                }
                            }
                        }
                    }.listStyle(InsetGroupedListStyle())
                }
            }
            .onAppear {
                logListVM.GetLogs(registration: "FV58BTGP")
            }
            .navigationTitle("Logs")
            .toolbar(content : {
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        logListVM.showAddLog()
                    }label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            })
            .sheet(isPresented: $logListVM.isShowingAddLogView) {
                AddLogView()
            }
        }
    }
}

struct LogDetailView: View {
    var logViewModel: LogViewModel

    var body: some View {
        VStack {
            Text("Date: \(logViewModel.formattedDate)")
            Text("Distance: \(logViewModel.formattedDistance)")
            Text("Liters Purchased: \(logViewModel.formattedLitersPurchase)")
            Text("Total Cost: \(logViewModel.formattedTotalCost)")
            // Add more details as needed
        }
        .navigationTitle("Log Details")
    }
}

#Preview {
    LogView()
}
