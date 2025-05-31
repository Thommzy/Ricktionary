//
//  MockCredentialStore.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/31/25.
//

@testable import Ricktionary

class MockCredentialStore: CredentialStoreProtocol {
    var storedUsername: String?
    var storedPassword: String?

    func save(username: String, password: String) -> Bool {
        self.storedUsername = username
        self.storedPassword = password
        return true
    }

    func retrieveCredentials() -> (username: String, password: String)? {
        guard let username = storedUsername, let password = storedPassword else { return nil }
        return (username, password)
    }

    func clearCredentials() -> Bool {
        storedUsername = nil
        storedPassword = nil
        return true
    }
}
