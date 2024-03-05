//
//  AuthViewModel.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/05.
//

import Foundation

class AuthViewModel: ObservableObject {
     var usernameText: String = ""
     var passwordText: String = ""
    
    @Published var isAuthenitcated: Bool = false

    
    
    func authenticate() {
        let defaults = UserDefaults.standard

        Webservice().login(username: usernameText, password: passwordText) { result in
            switch result {
            case .success(let token):
                print(token)
                defaults.setValue(token, forKey: "authtoken")
                DispatchQueue.main.async {
                    self.isAuthenitcated = true
                    print(self.isAuthenitcated)
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
   
    }
    
}
