# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a HarmonyOS application that provides a MCP (Model Context Protocol) explorer interface for querying location-based services through Amap APIs. The app allows users to perform various location-based queries including weather, POI search, nearby search, distance calculation, and cycling route planning.

## Build System and Commands

This project uses Hvigor as its build system, which is HarmonyOS's official build tool.

### Common Build Commands
- **Build the project**: Use DevEco Studio's built-in build system or Hvigor commands
- **Run tests**: Execute test targets through DevEco Studio
- **Lint checking**: Configure through `code-linter.json5` with TypeScript ESLint rules and security rules

### Code Quality
The project is configured with:
- TypeScript ESLint with performance and security rules
- Code obfuscation settings for release builds (currently disabled)
- Strict mode enabled for case-sensitive checks

## Architecture Overview

### Main Application Structure
```
entry/src/main/ets/
├── entryability/         # Application lifecycle management
├── pages/               # UI pages (Index, ResultPage)
├── types/               # TypeScript type definitions
└── utils/               # Utilities (HTTP client, configuration)
```

### Key Components

**Entry Point**: `EntryAbility.ets` - Standard HarmonyOS UIAbility that loads the main Index page

**Main Page**: `pages/Index.ets` - Dynamic form interface that:
- Displays query type selection (weather, POI, nearby search, etc.)
- Renders dynamic form fields based on selected query type
- Validates input and navigates to results page

**Type System**: `types/ApiTypes.ets` - Comprehensive type definitions for:
- Query parameters for different API types
- API request/response structures
- SSE (Server-Sent Events) data parsing
- Route parameters and result data

**Configuration**: `utils/config.ets` - Query option configurations defining:
- Available query types with icons and descriptions  
- Dynamic form field definitions for each query type
- Validation rules and placeholders

**HTTP Client**: `utils/HttpClient.ets` - Network layer that:
- Makes requests to external MCP API endpoints
- Parses SSE streaming responses
- Handles authentication with bearer tokens
- Provides structured error handling

### Data Flow
1. User selects query type from configured options in Index page
2. Dynamic form fields are generated based on query configuration
3. Form validation ensures required fields are completed
4. Query parameters are built and sent via HttpClient
5. SSE streaming response is parsed and structured
6. Results are displayed in ResultPage

### Configuration Management
The app uses a centralized configuration system where query options are defined with:
- Type identifiers and display labels
- Required form fields with validation
- Icons and descriptions for user interface
- Enable/disable flags for feature toggling

## Development Notes

- The app targets HarmonyOS 5.1.0 (API level 18)
- Uses ArkTS (extended TypeScript) for UI development
- Implements reactive state management with `@State` decorators
- Uses `@Builder` decorators for reusable UI components
- HTTP requests include 2-minute timeouts for MCP API calls
- Security rules are enforced for cryptographic operations

## Test Structure
- Unit tests in `entry/src/test/`
- Integration tests in `entry/src/ohosTest/`
- Uses Hypium testing framework and Hamock for mocking