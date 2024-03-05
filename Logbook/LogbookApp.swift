//
//  LogbookApp.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/05.
//

import SwiftUI

@main
struct LogbookApp: App {
    @StateObject  var viewModel: AuthViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            if viewModel.isAuthenitcated {
                MainView()
                    .environmentObject(viewModel)

            }else {
                AuthView(viewModel: viewModel)
                    .environmentObject(viewModel)

            }
        }
    }
}
