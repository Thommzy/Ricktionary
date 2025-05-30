//
//  AuthenticationService.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/29/25.
//

import Foundation

class AuthenticationService {
    let credentialStore: CredentialStoreProtocol
    private let biometricAuth: BiometricAuthProtocol

    init(credentialStore: CredentialStoreProtocol, biometricAuth: BiometricAuthProtocol) {
        self.credentialStore = credentialStore
        self.biometricAuth = biometricAuth
    }

    func login(username: String, password: String) -> Bool {
        if let creds = credentialStore.retrieveCredentials() {
            return creds.username == username && creds.password == password
        } else {
            return credentialStore.save(username: username, password: password)
        }
    }

    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        biometricAuth.authenticateUser(completion: completion)
    }

    func hasCredentials() -> Bool {
        return credentialStore.retrieveCredentials() != nil
    }
}
