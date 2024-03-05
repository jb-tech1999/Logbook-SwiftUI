//
//  AuthView.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/05.
//

import SwiftUI


struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel = AuthViewModel()
    @ObservedObject var carsListViewModel = CarListViewModel()
    
    
    var body: some View {
        VStack {
            Image(systemName: viewModel.isAuthenitcated ? "lock.fill" : "lock.open")
            TextField("Username", text: $viewModel.usernameText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .textInputAutocapitalization(.never)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            SecureField("Password", text:$viewModel.passwordText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .textInputAutocapitalization(.never)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Button {
                viewModel.authenticate()
            } label: {
                Text("Sign in")
            }.padding()
                .foregroundStyle(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

        }
        .padding()

        
        
        
    }
}

#Preview {
    AuthView()
}

