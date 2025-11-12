# Capital List

A modern iOS application built with SwiftUI that allows users to explore and manage their favorite countries. The app fetches country data from the REST Countries API and provides a beautiful, intuitive interface for browsing country information including capitals, currencies, and more.

## Features

- 🌍 **Country Search & Discovery**: Search and browse countries from around the world
- ⭐ **Favorite Countries**: Save up to 5 favorite countries for quick access
- 📍 **Location-Based Default**: Automatically detects your location and adds your country to favorites
- 🎨 **Modern UI/UX**: Beautiful gradient backgrounds, card-based design, and smooth animations
- 🌓 **Theme Support**: Light and dark mode support with seamless theme switching
- 📱 **SwiftUI Native**: Built entirely with SwiftUI for a native iOS experience
- 💾 **Persistent Storage**: Uses SwiftData for local persistence of favorite countries
- 🔍 **Country Details**: View detailed information about each country including capital and currency

## Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

### Layer Structure

- **Domain Layer**: Core business logic, models, protocols, and use cases
  - Models: `Country`, `CountryName`, `Currency`
  - Protocols: Repository protocols, service protocols
  - Use Cases: Business logic for fetching, searching, and managing favorites

- **Data Layer**: Data sources, repositories, and network services
  - Repositories: Implementation of domain protocols
  - Network: API service for REST Countries API integration
  - Models: DTOs for data transfer

- **Presentation Layer**: SwiftUI views and view models
  - Views: SwiftUI components and screens
  - ViewModels: Observable view models using Swift's `@Observable` macro

- **Design System**: Reusable UI components and theming
  - Components: `CardView`, `EmptyStateView`, `PrimaryButton`, etc.
  - Theme: Centralized color, typography, and spacing system

## Tech Stack

- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Local data persistence
- **Async/Await**: Modern concurrency for network operations
- **Actor Model**: Thread-safe API service implementation
- **Dependency Injection**: Custom dependency container for modular architecture
- **REST Countries API**: External API for country data

## Project Structure

```
Capital List/
├── Capital List/
│   ├── Core/
│   │   ├── Constants.swift          # App-wide constants
│   │   └── DependencyContainer.swift # DI container
│   ├── Data/
│   │   ├── Models/                   # Data transfer objects
│   │   ├── Network/                  # API service
│   │   ├── Repositories/             # Repository implementations
│   │   └── Services/                 # Location service, logger
│   ├── Domain/
│   │   ├── Models/                   # Domain models
│   │   ├── Protocols/                # Protocol definitions
│   │   ├── Repositories/             # Repository protocols
│   │   ├── Services/                 # Service protocols
│   │   └── UseCases/                 # Business logic
│   ├── Presentation/
│   │   ├── Views/                    # SwiftUI views
│   │   └── ViewModels/               # View models
│   ├── DesignSystem/
│   │   ├── Components/               # Reusable UI components
│   │   ├── Modifiers/                # View modifiers
│   │   └── Theme/                    # Theme system
│   └── Utils/
│       └── Logger.swift              # Logging utility
├── Capital ListTests/                # Unit tests
└── Capital ListUITests/              # UI tests
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Capital-List
   ```

2. **Open the project**
   ```bash
   open "Capital List.xcodeproj"
   ```

3. **Build and run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## Usage

### Adding Countries

1. Tap the **+** button in the top-right corner
2. Search for a country by name
3. Select a country from the search results
4. The country will be added to your favorites list

### Viewing Country Details

- Tap on any country card to view detailed information

### Removing Countries

- Tap the trash icon on any country card to remove it from your favorites

### Theme Toggle

- Use the theme toggle button in the top-left corner to switch between light and dark modes

### Location-Based Default

- On first launch, the app will attempt to detect your location and automatically add your country to favorites
- If location detection fails, it defaults to the United States (US)

## API Integration

The app uses the [REST Countries API](https://restcountries.com/) to fetch country data:

- **Base URL**: `https://restcountries.com/v3.1`
- **Fields**: `name`, `capital`, `currencies`, `cca2`
- **Endpoints Used**:
  - `/all` - Fetch all countries
  - `/name/{name}` - Search countries by name
  - `/alpha/{code}` - Get country by country code

## Testing

The project includes unit tests and UI tests:

- **Unit Tests**: Located in `Capital ListTests/`

Run tests using `Cmd + U` in Xcode.

## Design System

The app uses a centralized design system with:

- **Colors**: Primary, accent, background, text, and semantic colors
- **Typography**: Consistent font styles and sizes
- **Spacing**: Standardized spacing values
- **Components**: Reusable UI components following design system guidelines

## Limitations

- Maximum of 5 favorite countries can be saved
- Requires internet connection for searching and fetching country data
- Location services require user permission

## Future Enhancements

Potential improvements for future versions:

- [ ] Offline mode with cached country data
- [ ] More detailed country information (population, area, etc.)
- [ ] Country flags display
- [ ] Share favorite countries
- [ ] Export favorites list
- [ ] Multiple language support

## Author

**Mohamed Gamal**

## License

This project is available for use as specified in the repository.

---

Made with ❤️ using SwiftUI

