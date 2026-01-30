# Project Cleanup Plan - J-Recovery (STARA App)

## Executive Summary

After thorough analysis of the project structure, I've identified numerous unused files that can be safely deleted. The project has a complex structure with a main Flutter app located in `lib/linguaLoop/` while the root level contains unused template files and documentation that are not being used by the active application.

---

## Files/Folders to DELETE

### 1. Root-Level Unused Files (Flutter Template - Not Used)

These files are default Flutter template files at the root level. The actual app runs from `lib/linguaLoop/`:

| File/Folder | Reason |
|-------------|--------|
| [`lib/main.dart`](lib/main.dart:1) | Default Flutter template, not used - real app is at `lib/linguaLoop/lib/main.dart` |
| [`pubspec.yaml`](pubspec.yaml:1) | Root pubspec, not used - real config is at `lib/linguaLoop/pubspec.yaml` |
| [`pubspec.lock`](pubspec.lock:1) | Lock file for unused root pubspec |

### 2. Unused Markdown Documentation Files

These markdown files appear to be design documents and mockups that are not referenced by the application:

| File | Reason |
|------|--------|
| [`GOVERNOR_UI_MOCKUP.md`](GOVERNOR_UI_MOCKUP.md:1) | Design mockup document, not used by app |
| [`HOME_SCREEN_LAYOUT.md`](HOME_SCREEN_LAYOUT.md:1) | Layout guide, not used by app |
| [`HOME_SCREEN_REDESIGN.md`](HOME_SCREEN_REDESIGN.md:1) | Redesign notes, not used by app |
| [`REDESIGN_SUMMARY.md`](REDESIGN_SUMMARY.md:1) | Redesign summary, not used by app |
| [`TESTING_GUIDE.md`](TESTING_GUIDE.md:1) | Testing documentation, not used by app |

### 3. Unused SVG Files

| File | Reason |
|------|--------|
| [`STARA_MOCKUP.svg`](STARA_MOCKUP.svg:1) | Mockup file, not referenced in app |
| [`STARA_MOCKUP_CLEAN.svg`](STARA_MOCKUP_CLEAN.svg:1) | Mockup file, not referenced in app |

### 4. Unused Asset Files in `lib/linguaLoop/assets/`

**Animations folder** - Only `ringan.mp4` is used in [`splash_screen.dart`](lib/linguaLoop/lib/splash_screen.dart:57):

| File | Status |
|------|--------|
| `assets/animations/alpha.gif` | **UNUSED** - Not referenced |
| `assets/animations/ani.gif` | **UNUSED** - Not referenced |
| `assets/animations/loading_screen.mp4` | **UNUSED** - Not referenced |
| `assets/animations/png.gif` | **UNUSED** - Not referenced |
| `assets/animations/ringan.mp4` | **KEEP** - Used in splash screen |

**Icons folder**:

| File | Status |
|------|--------|
| `assets/icons/Sad man walking in rain.mp4` | **UNUSED** - Not referenced |

**Images folder** - `jelly.jpg` is used in [`profile_screen.dart`](lib/linguaLoop/lib/profile_screen.dart:209):

| File | Status |
|------|--------|
| `assets/images/jelly.jpg` | **KEEP** - Used in profile screen |
| `assets/images/logo.png` | **KEEP** - Referenced in pubspec.yaml |
| `assets/images/logo_white.png` | **KEEP** - Referenced in pubspec.yaml |
| `assets/images/statistik.png` | **KEEP** - Referenced in pubspec.yaml |

**Maps folder**:

| File | Status |
|------|--------|
| `assets/maps/wired-outline-18-location-pin-hover-jump.mp4` | **UNUSED** - Not referenced |

### 5. Unused Route Files in `lib/linguaLoop/routes/`

The main [`server.js`](lib/linguaLoop/server.js:1) defines all routes inline and does NOT import any files from the `routes/` folder. These files are completely unused:

| File | Status |
|------|--------|
| [`routes/data.js`](lib/linguaLoop/routes/data.js:1) | **UNUSED** - Not imported by server.js |
| [`routes/export.js`](lib/linguaLoop/routes/export.js:1) | **UNUSED** - Not imported by server.js |
| [`routes/infografis.js`](lib/linguaLoop/routes/infografis.js:1) | **UNUSED** - Not imported by server.js |
| [`routes/kategori.js`](lib/linguaLoop/routes/kategori.js:1) | **UNUSED** - Not imported by server.js |
| [`routes/publikasi.js`](lib/linguaLoop/routes/publikasi.js:1) | **UNUSED** - Not imported by server.js |
| [`routes/statistik.js`](lib/linguaLoop/routes/statistik.js:1) | **UNUSED** - Not imported by server.js |
| [`routes/wilayah.js`](lib/linguaLoop/routes/wilayah.js:1) | **UNUSED** - Not imported by server.js |

### 6. Unused Test Files

| File | Status |
|------|--------|
| [`lib/linguaLoop/test/widget_test.dart`](lib/linguaLoop/test/widget_test.dart:1) | **UNUSED** - Default Flutter test, tests counter app that doesn't exist |

### 7. Unused Server File

| File | Status |
|------|--------|
| [`lib/linguaLoop/test-server.js`](lib/linguaLoop/test-server.js:1) | **UNUSED** - Simple test server, not the main server.js |

### 8. Unused Root-Level Config Files

| File | Status |
|------|--------|
| [`analysis_options.yaml`](analysis_options.yaml:1) | **UNUSED** - Root level, real one is in `lib/linguaLoop/analysis_options.yaml` |
| [`.metadata`](.metadata:1) | Flutter template metadata, may be unused |

---

## Files to KEEP (Critical for App)

### Root Level
- [`.gitignore`](.gitignore:1) - Git configuration
- [`README.md`](README.md:1) - Project documentation

### Main App (`lib/linguaLoop/`)
- All files in `lib/` (Dart source code)
- [`lib/linguaLoop/pubspec.yaml`](lib/linguaLoop/pubspec.yaml:1) - Main Flutter config
- [`lib/linguaLoop/server.js`](lib/linguaLoop/server.js:1) - Main Express server
- [`lib/linguaLoop/package.json`](lib/linguaLoop/package.json:1) - Node.js dependencies
- All font files in `assets/fonts/`
- Used image assets (logo.png, logo_white.png, statistik.png, jelly.jpg)
- Used animation (ringan.mp4)
- Android and iOS configuration folders

---

## Summary of Deletions

| Category | Count | Items |
|----------|-------|-------|
| Root-level Flutter files | 3 | lib/main.dart, pubspec.yaml, pubspec.lock |
| Markdown docs | 5 | GOVERNOR_UI_MOCKUP.md, HOME_SCREEN_LAYOUT.md, HOME_SCREEN_REDESIGN.md, REDESIGN_SUMMARY.md, TESTING_GUIDE.md |
| SVG mockups | 2 | STARA_MOCKUP.svg, STARA_MOCKUP_CLEAN.svg |
| Unused animations | 4 | alpha.gif, ani.gif, loading_screen.mp4, png.gif |
| Unused icons | 1 | Sad man walking in rain.mp4 |
| Unused maps | 1 | wired-outline-18-location-pin-hover-jump.mp4 |
| Unused route files | 7 | All 7 files in routes/ folder |
| Unused test files | 1 | widget_test.dart |
| Unused server | 1 | test-server.js |
| Unused config | 2 | analysis_options.yaml, .metadata |

**Total: ~27 files/folders to delete**

---

## Action Required

Please review this plan. If approved, I will proceed to delete all identified unused files using the `delete_file` tool.

**Note:** The route files in `lib/linguaLoop/routes/` appear to be well-structured Express route handlers but are completely unused since `server.js` defines all routes inline. If you plan to refactor the server to use these route files in the future, let me know and I will keep them.
