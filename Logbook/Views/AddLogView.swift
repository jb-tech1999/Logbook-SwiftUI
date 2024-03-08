//
//  AddLogView.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/06.
//

import SwiftUI

struct AddLogView: View {
    @ObservedObject var  carListVM = CarListViewModel()
    @State private var carRegistration: String?

    @ObservedObject var addLogVM = addLogViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    DatePicker("Date", selection: $addLogVM.date).datePickerStyle(.compact)
                    TextField("Speedometer", text: Binding(
                        get: { String(addLogVM.odometer ?? 0) },
                        set: { addLogVM.odometer = Int($0) ?? 0 }
                    ))
                    TextField("Distance", text: Binding(
                        get: { String(addLogVM.distance ?? 0) },
                        set: { addLogVM.distance = Double($0) ?? 0 }
                    ))
                    TextField("Garage", text: $addLogVM.garage)
                    TextField("Total Cost", text: Binding(
                        get: { String(addLogVM.totalcost ?? 0) },
                        set: { addLogVM.totalcost = Double($0) ?? 0 }
                    ))
                    TextField("Liters Purchased", text: Binding(
                        get: { String(addLogVM.litersPurchase ?? 0) },
                        set: { addLogVM.litersPurchase = Double($0) ?? 0 }
                    ))
                    
                    Text("Selected Car: \(addLogVM.carRegistration ?? "None")")
                    Picker("Select Registration", selection: $addLogVM.carRegistration){
                        ForEach(carListVM.cars, id: \.self) { car in
                            Text(car.registration).tag(car.registration as String?)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
  
                }
                Button {
                    addLogVM.saveLog()
                } label: {
                    Text("Add Log")
                }.padding()
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            
            .alert(isPresented: $addLogVM.isAdded) {
                Alert(
                    title: Text("Success"),
                    message: Text("Log added"),
                    dismissButton: .default(Text("OK"))
                    )

        }
        }.onAppear{
            carListVM.getAllCars()
        }
        

    }
        
}

#Preview {
    AddLogView()
}


//"logid": 0,
//"user_id": 0,
//"carRegistration": "string",
//"date": "2024-03-05T06:25:12.535119",
//"odometer": 0,
//"distance": 0,
//"litersPurchase": 0,
//"garage": "string",
//"totalcost": 0
