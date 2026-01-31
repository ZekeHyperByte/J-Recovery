# STARA Project Overview

## Quick Summary
**Project Name**: STARA (Statistik Indonesia) / BPS Statistik Kota Semarang
**Type**: Hybrid Flutter mobile app + Node.js Express API
**Purpose**: Statistics information platform for Semarang City (BPS - Indonesian Statistics Agency)
**Architecture**: Flutter frontend with local storage + optional Node.js backend API

## Tech Stack

### Frontend (Flutter)
- **Language**: Dart 3.0+
- **Framework**: Flutter 3.10+
- **UI**: Material Design
- **State Management**: Provider + GetX
- **Storage**: SharedPreferences (local), Hive
- **Charts**: fl_chart, syncfusion_flutter_charts
- **Networking**: http, dio

### Backend (Node.js)
- **Runtime**: Node.js v25.1.0
- **Framework**: Express.js
- **Database**: MySQL + Sequelize ORM, Redis caching
- **Auth**: JWT + bcryptjs
- **Security**: Helmet, CORS, rate-limit
- **API Base**: `http://10.0.2.2:3000/api` (Android emulator)

### Platform Support
Android (min SDK 21), iOS (12+), Web, Linux, macOS, Windows

## Project Structure

```
/home/qiu/J-Recovery/
├── lib/linguaLoop/              # Main application code
│   ├── *.dart                   # 40+ screen/service files
│   ├── server.js                # Express API server
│   ├── package.json             # Node.js dependencies
│   ├── pubspec.yaml             # Flutter dependencies (main)
│   ├── routes/                  # API route handlers
│   │   ├── data.js
│   │   ├── statistik.js
│   │   ├── publikasi.js
│   │   └── [5 more]
│   └── assets/                  # Images, fonts, animations
├── android/                     # Android native config
├── ios/                         # iOS native config
├── pubspec.yaml                 # Root Flutter config (minimal)
└── README.md
```

## Key Application Features

### 10 Statistical Categories
1. **Penduduk** (Population) - Population statistics
2. **Pertumbuhan Ekonomi** (Economic Growth) - Economic indicators
3. **Inflasi** (Inflation) - Inflation data
4. **Pendidikan** (Education) - Education metrics
5. **Kemiskinan** (Poverty) - Poverty statistics
6. **Tenaga Kerja** (Labor Force) - Employment data
7. **IPM** (Human Development Index) - HDI metrics
8. **IPG** (Gender Development Index) - Gender equality
9. **IDG** (Gender Inequality Index) - Gender disparity
10. **SDGs** (Sustainable Development Goals) - SDG indicators

### User Roles
- **Public Users**: Browse all statistics (read-only)
- **Admin**: Manage data via admin panels (username: `admin`, password: `admin123`)

## Setup Instructions

### Prerequisites
```bash
# Required
- Flutter SDK 3.10+ (NOT currently installed)
- Node.js v14+ (currently installed: v25.1.0)
- MySQL 5.7+ (for backend, if using)
- Redis (optional, for caching)

# Platform-specific
- Android Studio + Android SDK (for Android)
- Xcode (for iOS, macOS only)
```

### Quick Start
```bash
# 1. Install Flutter dependencies
cd /home/qiu/J-Recovery/lib/linguaLoop
flutter pub get

# 2. Install Node.js dependencies
npm install

# 3. Create .env file
cat > .env << 'EOF'
PORT=3000
NODE_ENV=development
DB_HOST=localhost
DB_USER=your_mysql_user
DB_PASSWORD=your_mysql_password
DB_NAME=statistik_indonesia
REDIS_HOST=localhost
REDIS_PORT=6379
JWT_SECRET=your_secret_key_here
EOF

# 4. Start backend server
npm run dev

# 5. Run Flutter app (new terminal)
flutter run
```

### Important Configuration
- **API URL**: Set in `lib/linguaLoop/api_services.dart` → `baseUrl = 'http://10.0.2.2:3000/api'`
- **CORS Origins**: Configured in `lib/linguaLoop/server.js`
- **Rate Limit**: 100 requests/15 minutes
- **Admin Credentials**: Hardcoded in login screen

## Critical Files Reference

### For UI Changes
| Task | Files to Check |
|------|---------------|
| Home screen | `lib/linguaLoop/HomeScreen.dart`, `lib/linguaLoop/HomeAdminScreen.dart` |
| Splash screen | `lib/linguaLoop/SplashScreen.dart` |
| Login/Auth | `lib/linguaLoop/LoginScreen.dart` |
| Population stats | `lib/linguaLoop/PendudukScreen.dart`, `lib/linguaLoop/AdminPendudukScreen.dart` |
| Inflation stats | `lib/linguaLoop/InflasiScreen.dart`, `lib/linguaLoop/AdminInflasiScreen.dart` |
| Education stats | `lib/linguaLoop/education_screen.dart`, `lib/linguaLoop/admin_education_screen.dart` |
| SDGs dashboard | `lib/linguaLoop/sdgs_screen.dart`, `lib/linguaLoop/AdminSDGsScreen.dart` |
| Economic growth | `lib/linguaLoop/pertumbuhan_ekonomi_screen.dart`, `lib/lingualoop/AdminPertumbuhanEkonomiScreen.dart` |

### For Data/State Management
| Task | Files to Check |
|------|---------------|
| Education data service | `lib/linguaLoop/education_data_service.dart` |
| SDGs data model | `lib/linguaLoop/kota_data.dart` |
| API client | `lib/linguaLoop/api_services.dart` |
| SharedPreferences keys | Check individual screen files |

### For Backend/API Changes
| Task | Files to Check |
|------|---------------|
| Server setup | `lib/linguaLoop/server.js` |
| Statistics routes | `lib/linguaLoop/routes/statistik.js` |
| Publications routes | `lib/linguaLoop/routes/publikasi.js` |
| Data export | `lib/linguaLoop/routes/export.js` |
| Regions/areas | `lib/linguaLoop/routes/wilayah.js` |
| Test server | `lib/linguaLoop/test-server.js` |

### For Platform Config
| Task | Files to Check |
|------|---------------|
| Android config | `android/app/build.gradle.kts` |
| iOS config | `ios/Runner/Info.plist` |
| Flutter dependencies | `lib/linguaLoop/pubspec.yaml` |
| Node.js dependencies | `lib/linguaLoop/package.json` |
| Gradle properties | `android/gradle.properties` |

## Data Architecture

### Storage Pattern
- **Primary**: SharedPreferences (local storage)
- **Backend**: Optional MySQL database (configured but using sample data)
- **Structure**: Year-based data (2020-2024) per category

### Data Flow
1. App initializes with default data on first run
2. Data persists in SharedPreferences
3. Admin updates through admin panels
4. Changes saved locally and reflected immediately
5. Backend API available but app works offline-first

### Key Data Models
- **EducationData**: Literacy rates, schooling years, enrollment
- **KotaData** (SDGs): City-based SDG indicators
- **IPM**: Human Development Index metrics
- Year-based structure across all categories

## Common Tasks

### Add New Statistical Category
1. Create screen file: `lib/linguaLoop/NewCategoryScreen.dart`
2. Create admin screen: `lib/linguaLoop/AdminNewCategoryScreen.dart`
3. Create data service: `lib/linguaLoop/new_category_data_service.dart`
4. Add navigation from `HomeScreen.dart`
5. Add admin navigation from `HomeAdminScreen.dart`
6. Update assets in `lib/linguaLoop/pubspec.yaml` if needed

### Modify Chart/Visualization
- Check screen file for category (e.g., `PendudukScreen.dart`)
- Charts use `fl_chart` package
- Look for `LineChart`, `BarChart`, or `PieChart` widgets

### Update API Endpoint
1. Modify route file in `lib/linguaLoop/routes/`
2. Restart backend: `npm run dev`
3. Update API service if needed: `lib/linguaLoop/api_services.dart`

### Change Admin Credentials
- File: `lib/linguaLoop/LoginScreen.dart`
- Find hardcoded check: `username == 'admin' && password == 'admin123'`

### Add New Dependency
```bash
# Flutter
cd /home/qiu/J-Recovery/lib/linguaLoop
flutter pub add package_name

# Node.js
cd /home/qiu/J-Recovery/lib/linguaLoop
npm install package-name
```

## API Endpoints Reference

```
Base: http://10.0.2.2:3000/api

Statistics:
- GET /statistik/terbaru
- GET /statistik?kategori={category}

Publications:
- GET /publikasi/recent
- GET /publikasi?page={n}&limit={n}

Data:
- GET /data/{dataId}?tahun={year}
- GET /data/search?query={q}

Regions:
- GET /wilayah/provinsi
- GET /wilayah/kabupaten?provinsi={id}

Export:
- GET /export/{dataId}?format={format}
```

## Known Limitations

1. **Flutter SDK Not Installed**: Need to install Flutter before running
2. **Hardcoded Credentials**: Admin auth is basic, not production-ready
3. **No .env File**: Must create manually for backend
4. **Mixed Data Sources**: App uses local storage, backend has separate data
5. **API Keys**: Google Maps and Syncfusion require setup

## Build Commands

```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web

# Run tests
flutter test
npm test
```

## Dependencies Count
- **Flutter**: 37 runtime + 7 dev packages
- **Node.js**: 15 runtime + 3 dev packages

## Additional Notes
- App works offline-first with local storage
- Backend is optional but provides additional features
- Charts require data for years 2020-2024
- Material Design with custom fonts (Poppins, Montserrat)
- Rate limiting on API prevents abuse
- Includes admin CRUD functionality for all categories
