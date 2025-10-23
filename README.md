Flutter Starter Template 🚀

A comprehensive Flutter starter project with essential features and best practices pre-configured for rapid development.
✨ Features
🌐 Internationalization & Localization

    Easy localization support for Arabic (ar) and English (en)

    Simple translation extension for seamless text localization

    Easy to extend for additional languages

🎨 Theme & Styling

    Custom theme system with flexible color schemes

    Dynamic color theming - change app colors dynamically

    Light and dark theme support out of the box

    Consistent design system across the entire app

💾 Data Persistence

Choose your preferred database solution:

    Hive - Lightweight & fast NoSQL database

    SQLite via sqflite - Robust relational database

    Generic CRUD operations for both databases

    Ready-to-use database connection classes

🌐 API Integration

    Dio HTTP Client - Powerful API helper class

    Authentication token handling with automatic injection

    Request/Response interceptors for centralized API management

    Automatic token refresh and retry mechanisms

    Comprehensive error handling

🔐 Security & Storage

    Secure token storage using Shared Preferences

    Local data management utilities

    Safe credential handling

🚀 Getting Started
Prerequisites

    Flutter SDK (latest stable version)

    Dart SDK

    Your favorite IDE (Android Studio, VS Code, or IntelliJ)

Installation

    Clone the repository
    bash

git clone https://github.com/MuaathMohammed/muaath_start_point_project.git
cd muaath_start_point_project

Get dependencies
bash

flutter pub get

Run the app
bash

flutter run

📁 Project Structure
text

    lib/
    ├── core/
    │   ├── constants/      # App constants and configurations
    │   ├── config/         # App  configurations
    │   ├── services/       # Business logic services
    │   ├── themes/         # Theme configurations
    │   └── utils/          # Utility classes and helpers
    ├── data/
    │   ├── models/         # Data models
    │   ├── repositories/   # Data repositories
    │   └── datasources/    # Local & remote data sources
    ├── domain/
    │   ├── entities/       # Business entities
    │   └── repositories/   # Repository interfaces
    ├── presentation/
    │   ├── pages/          # App screens
    │   ├── widgets/        # Reusable widgets
    ├── providers/# State management
    └── main.dart          # App entry point

🤝 Contributing

    Fork the project

    Create your feature branch (git checkout -b feature/AmazingFeature)

    Commit your changes (git commit -m 'Add some AmazingFeature')

    Push to the branch (git push origin feature/AmazingFeature)

    Open a Pull Request

📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

🙏 Acknowledgments

    Flutter team for the amazing framework

    Package contributors for the excellent libraries

    Community for continuous improvements

This starter template is maintained by Muaath Mohammed Japer -  Moj774418@gmail.com
