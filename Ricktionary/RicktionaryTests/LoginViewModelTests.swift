//
//  LoginViewModelTests.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/30/25.
//

import XCTest
@testable import Ricktionary

// MARK: - Mocks

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

class MockBiometricAuth: BiometricAuthProtocol {
    var shouldSucceed = true
    var error: Error?

    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        completion(shouldSucceed, error)
    }
}

final class LoginViewModelTests: XCTestCase {
    
    var credentialStore: MockCredentialStore!
    var biometricAuth: MockBiometricAuth!
    var authService: AuthenticationService!
    var viewModel: LoginViewModel!

    override func setUp() {
        credentialStore = MockCredentialStore()
        biometricAuth = MockBiometricAuth()
        authService = AuthenticationService(credentialStore: credentialStore, biometricAuth: biometricAuth)
        viewModel = LoginViewModel(authService: authService)
    }

    override func tearDown() {
        credentialStore = nil
        biometricAuth = nil
        authService = nil
        viewModel = nil
    }

    func testLogin_withEmptyCredentials_setsError() {
        viewModel.username = ""
        viewModel.password = ""
        
        viewModel.login()

        XCTAssertEqual(viewModel.loginError, "Please enter username and password.")
        XCTAssertFalse(viewModel.isLoggedIn)
    }

    func testLogin_withValidCredentials_logsInSuccessfully() {
        _ = credentialStore.save(username: "Tim", password: "1234")
        
        viewModel.username = "Tim"
        viewModel.password = "1234"
        viewModel.login()

        XCTAssertTrue(viewModel.isLoggedIn)
        XCTAssertNil(viewModel.loginError)
        XCTAssertTrue(viewModel.showBiometricLogin)
    }

    func testLogin_withInvalidCredentials_setsError() {
       _ = credentialStore.save(username: "Tim", password: "1234")

        viewModel.username = "Tim"
        viewModel.password = "wrong"

        viewModel.login()

        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertEqual(viewModel.loginError, "Invalid credentials.")
    }

    func testLoginWithBiometrics_success_setsLoginState() {
       _ = credentialStore.save(username: "BiometricUser", password: "securePass")
        biometricAuth.shouldSucceed = true

        let expectation = XCTestExpectation(description: "Biometric login completed")

        viewModel.loginWithBiometrics()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.username, "BiometricUser")
            XCTAssertEqual(self.viewModel.password, "securePass")
            XCTAssertTrue(self.viewModel.isLoggedIn)
            XCTAssertNil(self.viewModel.loginError)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testLoginWithBiometrics_failure_setsError() {
        biometricAuth.shouldSucceed = false
        biometricAuth.error = NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Biometric Failed"])

        let expectation = XCTestExpectation(description: "Biometric login failed")

        viewModel.loginWithBiometrics()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.loginError, "Biometric Failed")
            XCTAssertFalse(self.viewModel.isLoggedIn)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testInit_withStoredCredentials_setsShowBiometricLogin() {
        _ = credentialStore.save(username: "Stored", password: "creds")
        viewModel = LoginViewModel(authService: authService)

        XCTAssertTrue(viewModel.showBiometricLogin)
    }

    func testInit_withoutStoredCredentials_setsShowBiometricLoginToFalse() {
        viewModel = LoginViewModel(authService: authService)
        XCTAssertFalse(viewModel.showBiometricLogin)
    }
}
