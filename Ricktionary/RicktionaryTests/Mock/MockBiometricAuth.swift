//
//  MockBiometricAuth.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/31/25.
//

@testable import Ricktionary

class MockBiometricAuth: BiometricAuthProtocol {
    var shouldSucceed = true
    var error: Error?

    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        completion(shouldSucceed, error)
    }
}
