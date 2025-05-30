//
//  LoginViewModel.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/29/25.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var loginError: String?
    @Published var isLoggedIn: Bool = false
    @Published var showBiometricLogin: Bool = false

    private let authService: AuthenticationService

    init(authService: AuthenticationService) {
        self.authService = authService
        self.showBiometricLogin = authService.hasCredentials()
    }

    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            loginError = "Please enter username and password."
            return
        }

        if authService.login(username: username, password: password) {
            loginError = nil
            isLoggedIn = true
            showBiometricLogin = true
        } else {
            loginError = "Invalid credentials."
        }
        
    }

    func loginWithBiometrics() {
        authService.authenticateWithBiometrics { [weak self] success, error in
            if success, let creds = self?.authService.credentialStore.retrieveCredentials() {
                DispatchQueue.main.async {
                    self?.username = creds.username
                    self?.password = creds.password
                    self?.isLoggedIn = true
                    self?.loginError = nil
                }
            } else {
                DispatchQueue.main.async {
                    self?.loginError = error?.localizedDescription ?? "Biometric Authentication Failed."
                }
            }
        }
    }
}
