//
//  CarsView.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/05.
//

import SwiftUI

struct CarsView: View {
    
    @ObservedObject private var  viewModel: AuthViewModel = AuthViewModel()
    @ObservedObject var  carListVM = CarListViewModel()
    @State  var selectedCar: carViewModel?
    
    
    var body: some View {
        NavigationView {
            VStack {
                if  carListVM.cars.count > 0 {
                    List {
                        ForEach(carListVM.cars, id: \.self) { car in
                            NavigationLink(destination: CarDetailView(carViewModel: car)) {
                                HStack {
                                    Text("\(car.make)")
                                    Text("\(car.model)")
                                }
                            }
                            .swipeActions{
                                Button(role: .destructive) {
                                    carListVM.deleteCar(car: car)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
  
                        }
   
                        }
                    }
                }
            .navigationTitle("Cars")
       .toolbar(content : {
           ToolbarItem(placement: .topBarTrailing){
               Button {
                   carListVM.showAddCar()
                   
               }label: {
                   Image(systemName: "square.and.pencil")
               }
           }
       })
       .sheet(isPresented: $carListVM.isShowingAddCarView) {
           AddCarView()
       }
                
            }
            
            .onAppear{
                carListVM.getAllCars()
            }
        }
        }
    
        
    

struct CarDetailView: View {
    var carViewModel: carViewModel

    var body: some View {
        VStack {
            Text("Make: \(carViewModel.make)")
            Text("Model: \(carViewModel.model)")
            Text("Registration: \(carViewModel.registration)")
            // Add more details as needed
        }
        .navigationTitle("Car Details")
    }
}
        


#Preview {
    CarsView()
}
