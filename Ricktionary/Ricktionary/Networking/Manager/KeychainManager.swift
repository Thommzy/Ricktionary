//
//  KeychainManager.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/29/25.
//

import Foundation
import Security

protocol CredentialStoreProtocol {
    func save(username: String, password: String) -> Bool
    func retrieveCredentials() -> (username: String, password: String)?
    func clearCredentials() -> Bool
}

final class KeychainService: CredentialStoreProtocol {
    private let service = "com.example.Ricktionary"

    func save(username: String, password: String) -> Bool {
        guard let usernameData = username.data(using: .utf8),
              let passwordData = password.data(using: .utf8) else { return false }

        // Delete existing items first
        _ = clearCredentials()

        let usernameQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "username",
            kSecAttrService as String: service,
            kSecValueData as String: usernameData
        ]

        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "password",
            kSecAttrService as String: service,
            kSecValueData as String: passwordData
        ]

        let status1 = SecItemAdd(usernameQuery as CFDictionary, nil)
        let status2 = SecItemAdd(passwordQuery as CFDictionary, nil)

        return status1 == errSecSuccess && status2 == errSecSuccess
    }

    func retrieveCredentials() -> (username: String, password: String)? {
        func getItem(account: String) -> String? {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: account,
                kSecAttrService as String: service,
                kSecReturnData as String: kCFBooleanTrue!,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]

            var dataTypeRef: AnyObject?

            let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
            if status == errSecSuccess,
               let data = dataTypeRef as? Data,
               let value = String(data: data, encoding: .utf8) {
                return value
            }
            return nil
        }

        if let username = getItem(account: "username"),
           let password = getItem(account: "password") {
            return (username, password)
        }
        return nil
    }

    func clearCredentials() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
