# Zanis Data Communication Prototype

This project is a prototype for a data communication layer that interfaces with a Flutter application. It was developed as part of the interview challenge for Zanis.

## Introduction and Project Objective

The goal of this project is to create a data communication layer at the native level (Android) that can communicate with a Flutter application. In this prototype, instead of an actual USB connection, a data simulator is implemented that periodically generates random data and sends it to the Flutter application.

## Architecture and Design

### System Architecture

This project uses a multi-layered architecture:

1. **Native Layer (Android)**:
    - Contains Kotlin code for Android
    - Responsible for generating and managing data at the native level
    - Implementation of Singleton and Observer patterns

2. **Communication Layer (Method Channels)**:
    - Uses Method Channels for communication between native code and Flutter
    - Responsible for data transfer between layers

3. **Flutter Layer**:
    - User interface for displaying data
    - Data flow management using StreamController

### Design Patterns

1. **Singleton**:
    - Used in `DataCommunicationManager` to ensure only one instance of the data communication manager exists
    - Benefit: Centralized resource management and prevention of multiple unnecessary instances

2. **Observer**:
    - Implemented using callbacks and StreamController
    - Allows notification of data changes to multiple subscribers
    - Benefit: Separation of data producer and consumer

3. **Repository**:
    - Uses interface pattern for data access
    - Separates data access logic from business logic
    - Benefit: Better testability and flexibility

4. **Adapter**:
    - Converts data between different formats (ByteArray to JSON to Map)
    - Benefit: Compatibility between heterogeneous systems

## Technologies Used

- **Flutter**: Cross-platform framework for UI development
- **Dart**: Programming language used in Flutter
- **Kotlin**: Programming language for Android native code
- **Method Channels**: Communication mechanism between Flutter and native code
- **Android SDK**: For developing the native Android component

## Project Structure

```
├── android/                         # Android native code
│   └── app/src/main/kotlin/
│       └── com.example.zanis_data_communication/
│           ├── DataCommunicationManager.kt  # Data management and simulation
│           ├── FlutterDataPlugin.kt         # Flutter plugin
│           └── MainActivity.kt              # Main activity
│
├── lib/                            # Flutter code
│   ├── data_communication.dart     # Class for communicating with native code
│   └── main.dart                   # Main Flutter application
│
├── docs/                           # Documentation and audio files
│   ├── architecture-diagram.png    # Architecture diagram
│   ├── part1-voice-recording.mp3   # Voice recording for part 1
│   └── part3-voice-recording.mp3   # Voice recording for part 3
│
└── README.md
```

## Project Features

1. **Data Simulation**:
    - Generation of random data in JSON format
    - Automatic data transmission every second

2. **Connection Management**:
    - Management of bidirectional communication between native code and Flutter
    - Ability to start and stop data simulation

3. **Information Display**:
    - Display of device information (model, OS version)
    - Display of received data in a dynamic list

4. **Error Handling**:
    - Implementation of error handling at the Method Channel level
    - Logging errors for easier debugging

## Setup and Execution

### Prerequisites

- Flutter SDK (version 3.27.1)
- Android Studio
- An Android device or emulator

### Setup Steps

1. **Clone the project from GitHub**:
   ```bash
   git clone https://github.com/mehrdadmoradi001/ios-data-communication-challenge.git
   cd ios-data-communication-challenge

## Demonstration Video and Audio Link
```
├── Zanis/  # Documentation and audio files
│   ├── # Architectural approach, design patterns, etc Folder
│   ├── # Dibag and Code Review Folder
│   └── # System architecture diagram
```

- (https://drive.google.com/drive/folders/1zBk5gF0iWstFP1cIqwJR6iskdZEp2lqK?usp=sharing)
