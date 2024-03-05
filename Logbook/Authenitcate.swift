//
//  Authenitcate.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/05.
//

import SwiftUI

class Authenitcate: ObservableObject {
    @Published var isAuth = false
    
    func updateAuth(success: Bool) {
        withAnimation {
            isAuth = success
        }
    }
}
