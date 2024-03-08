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
    @ObservedObject var  carListVM = CarListViewModel()
    @State var carRegistration: String?
    
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
                
                Picker("Select Registration", selection: $carRegistration){
                    ForEach(carListVM.cars, id: \.self) { car in
                        Text(car.registration).tag(car.registration as String?)
                    }
                }
                
                //.onChange(of: carRegistration, action: (logListVM.GetLogs(registration:  carRegistration ?? ""))
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: carRegistration) {
                    logListVM.GetLogs(registration: carRegistration ?? "")
                }
                
                
                if sortedLogs.count > 0 {
                    List {
                        ForEach(sortedLogs, id: \.log.logid) { logViewModel in
                            NavigationLink (destination: LogDetailView(logViewModel: logViewModel)) {
                                HStack {
                                    Text("\(logViewModel.formattedDate)")
                                    Spacer()
                                    Text("Cost: \(logViewModel.formattedTotalCost)")
                                }
                            }
                        }
                    }.listStyle(InsetGroupedListStyle())
                }
            }
            .onAppear {
                carListVM.getAllCars()
                
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
            List {
                Section(header: Text("Date:")) {
                    Text("\(logViewModel.formattedDate)")
                }
                Section(header: Text("FuelEconomy  :")) {
                    Text("\(logViewModel.fueleconomy)")
                }
                Section(header: Text("Distance:")) {
                    Text("\(logViewModel.formattedDistance)")
                }
                Section(header: Text("Liters Purchased:")) {
                    Text("\(logViewModel.formattedLitersPurchase)")
                }
                Section(header: Text("Total Cost:")) {
                    Text("\(logViewModel.formattedTotalCost)")
                }
                Section(header: Text("Garage:")) {
                    Text("\(logViewModel.garage)")
                }
                
            }.listSectionSpacing(0)
            // Add more details as needed
        }
        .navigationTitle("Log Details")
    }
}

#Preview {
    LogView()
}
