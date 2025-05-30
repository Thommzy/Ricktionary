//
//  BiometricAuthManager.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/29/25.
//

import LocalAuthentication

protocol BiometricAuthProtocol {
    func authenticateUser(completion: @escaping (Bool, Error?) -> Void)
}

final class BiometricAuthManager: BiometricAuthProtocol {
    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Use Face ID / Touch ID to login"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    completion(success, authError)
                }
            }
        } else {
            completion(false, error)
        }
    }
}
