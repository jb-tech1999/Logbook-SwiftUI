//
//  LocationView.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/07.
//

import SwiftUI
import MapKit

struct LocationView: View {
    var locationVM = LocationViewModel()
    @State var locationQuery: String = ""
    


    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $locationQuery)
                Button {
                    locationVM.forwardGeocoding(address: locationQuery)
                }label: {
                    Text("Search")
                }.padding()
            }
            
            
            Map()
                .onMapCameraChange { context in
                    print(context.region)
                }
        }

    }
}

#Preview {
    LocationView()
}
