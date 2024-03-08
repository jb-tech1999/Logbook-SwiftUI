//
//  StatsView.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/06.
//

import SwiftUI
import Charts

struct StatsView: View {
    @ObservedObject var  logListVM = LogListViewModel()

    var body: some View {
        NavigationView {
 
        
            Text("PlaceHolder")
                .navigationTitle("Stats")
            
        }
    }
}
        
        


#Preview {
    StatsView()
}
