//
//  LoginView.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/29/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login").font(.largeTitle).bold()
            
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
            
            Button("Login") {
                viewModel.login()
            }
            .buttonStyle(.borderedProminent)
            
            if viewModel.showBiometricLogin {
                Button("Login with Face ID / Touch ID") {
                    viewModel.loginWithBiometrics()
                }
            }
            
            if let error = viewModel.loginError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .navigationDestination(isPresented: $viewModel.isLoggedIn) {
            HomeView(viewModel: createHomeViewModel())
                .navigationBarBackButtonHidden(true)
        }
    }
    
    func createHomeViewModel() -> HomeViewModel {
        let client = CharacterClient()
        let repo = CharacterRepository(client: client)
        return HomeViewModel(client: client, repository: repo)
    }
}
