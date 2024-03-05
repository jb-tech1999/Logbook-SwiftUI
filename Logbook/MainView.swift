//
//  MainView.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/05.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var  carListVM = CarListViewModel()

    var body: some View {
        

            TabView {
                LogView()
                    .tabItem {
                        Label("Logs", systemImage: "list.dash")
                    }
                CarsView()
                    .tabItem {
                        Label("Cars", systemImage: "car")
                    }
                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar")
                    }
                
                    
            }
            
        

    }
}

#Preview {
    MainView()
}
