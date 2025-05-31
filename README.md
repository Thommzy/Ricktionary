# Ricktionary

**Ricktionary** is a lightweight iOS application that displays a list of characters from the iconic *Rick and Morty* series. Built using modern Apple frameworks, the app demonstrates clean architecture, reactive programming, and modular components for maintainability and scalability.

---

## Features

-  Authentication service with Keychain encryption  
-  Character list with names  
-  Detailed character view with additional information  
-  Modular `ImageLoader` component for asynchronous image downloading and caching  
-  MVVM architecture powered by Combine  
-  Unit tests with mock data for validating business logic

---

## Requirements

- Xcode 16.0 or later  
- macOS Sequoia 15.3 or later  
- Swift 5.7 or later  
- iOS 16.0 or later *(adjust if needed)*

---

## Modules

### ImageLoader

A lightweight and reusable Swift module for asynchronously loading and displaying remote images in SwiftUI.

#### Features:
- Downloads images from a remote URL using `Data(contentsOf:)`
- Publishes the image as a `@Published` property for use in SwiftUI views
- Executes image loading on a background thread and updates the UI on the main thread
- Built with `Combine` and marked with `@MainActor` for thread safety

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/Thommzy/Ricktionary
cd Ricktionary
```

### 2. Open the Project in Xcode

```bash
open Ricktionary/Ricktionary.xcodeproj
```

### 3. Build and Run

- Select the **Ricktionary** scheme  
- Choose a simulator (e.g., iPhone 14)  
- Press `Cmd + R` to build and run

---

## Running Tests

**Ricktionary** includes unit tests for core components to ensure reliability and maintainability.

### How to Run

1. Open the project in Xcode  
2. Select the **Ricktionary** scheme  
3. Press `Cmd + U` or use the Test Navigator to run all tests

### What's Covered

- Unit tests for `LoginViewModel` and `HomeViewModel`  
- Mocked dependencies such as `MockBiometricAuth`, `MockClient`, `MockCredentialStore`, `MockRepository`, and `APIService`  
- Validation of authentication logic and data fetching  
- High test coverage for the logic layer

>  **Tip:** If you encounter issues, use `Cmd + Shift + K` to clean the build folder before running tests.

---

## How to Use

1. Launch the app  
2. Browse the list of *Rick and Morty* characters  
3. Tap on a character to view detailed information

---

## Troubleshooting

### Simulator Not Appearing?

- Ensure the selected simulator version matches your iOS deployment target  
- List available simulators with:

```bash
xcrun simctl list
```

### Module Import Issues?

- Confirm that the `ImageLoader` module is properly linked  
- Clean the build folder:

```bash
Cmd + Shift + K
```

- Rebuild the project:

```bash
Cmd + B
```

---

## Acknowledgements

- [Rick and Morty API](https://rickandmortyapi.com/) – for providing character data
