//
//  AddCarView.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/07.
//

import SwiftUI

struct AddCarView: View {
    
    @ObservedObject var addCarVM = AddCarViewModel()
    @ObservedObject var  carListVM = CarListViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            List {
                TextField("Make", text: $addCarVM.make)
                TextField("Model", text: $addCarVM.model)
                TextField("Registration", text: $addCarVM.registration)
                TextField("Year", text: Binding(
                    get: { String(addCarVM.year) },
                    set: { addCarVM.year = Int($0) ?? 0 }
                ))
            }
            Button {
                addCarVM.saveCar()
                carListVM.getAllCars()
                presentationMode.wrappedValue.dismiss()
            }label: {
                Text("Add car")
            }.padding()
                .foregroundStyle(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .alert(isPresented: $addCarVM.isAdded) {
            Alert(
                title: Text("Success"),
                message: Text("Log added"),
                dismissButton: .default(Text("OK"))
                )
            
                  

        }
        
    }
    
}

#Preview {
    AddCarView()
}
