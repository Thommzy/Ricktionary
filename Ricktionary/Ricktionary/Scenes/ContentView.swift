//
//  ContentView.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/29/25.
//

import SwiftUI

struct ContentView: View {
    private let keychainService = KeychainService()
    private let biometricAuth = BiometricAuthManager()
    private var authService: AuthenticationService {
        AuthenticationService(credentialStore: keychainService, biometricAuth: biometricAuth)
    }
    
    @StateObject private var loginViewModel = LoginViewModel(authService: AuthenticationService(
        credentialStore: KeychainService(), biometricAuth: BiometricAuthManager())
    )
    
    var body: some View {
        NavigationStack {
            LoginView(viewModel: loginViewModel)
        }
    }
}

#Preview {
    ContentView()
}
