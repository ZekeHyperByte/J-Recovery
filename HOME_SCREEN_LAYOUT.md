# Home Screen Visual Layout Guide

## Screen Structure (Top to Bottom)

```
┌─────────────────────────────────────────────┐
│  HEADER (Dark Slate #475569)               │
│  ┌─────────────────────────────────────┐   │
│  │ [Logo] BPS KOTA SEMARANG            │   │
│  │        Statistik Terpercaya         │   │
│  └─────────────────────────────────────┘   │
│  ┌─────────────────────────────────────┐   │
│  │ 🔍 Cari kategori statistik...   [×] │   │ ← FUNCTIONAL SEARCH
│  └─────────────────────────────────────┘   │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│  STATS SNAPSHOT SECTION                     │
│  📊 Snapshot Indikator Utama                │
│                                             │
│  ┌───────────────────────┐                 │
│  │ [Icon]  Penduduk      │ ← SWIPEABLE     │
│  │         1.709M  [+1.2%]│   CARDS        │
│  │         ▁▂▃▄█ chart   │   (4 cards)    │
│  └───────────────────────┘                 │
│                                             │
│  ● ○ ○ ○  ← Page indicators                │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│  CATEGORIES SECTION                         │
│  🎯 Jelajahi Statistik          [3 hasil]  │ ← Result count (if searching)
│                                             │
│  ⚙️ Indikator Ekonomi              [4]     │ ← Group header
│  ┌──────────────┬──────────────┐           │
│  │ [📊]      → │ [💰]      →  │           │
│  │             │              │           │
│  │ Ekonomi     │ Inflasi      │           │
│  │ Pertumbuhan │              │           │
│  │ Ekonomi     │              │           │
│  └──────────────┴──────────────┘           │
│  ┌──────────────┬──────────────┐           │
│  │ [💼]      → │ [🤝]      →  │           │
│  │             │              │           │
│  │ Ketenaga-   │ Kemiskinan   │           │
│  │ kerjaan     │              │           │
│  └──────────────┴──────────────┘           │
│                                             │
│  👥 Indikator Sosial               [2]     │
│  ┌──────────────┬──────────────┐           │
│  │ [👤]      → │ [🎓]      →  │           │
│  │             │              │           │
│  │ Penduduk    │ Pendidikan   │           │
│  └──────────────┴──────────────┘           │
│                                             │
│  🚀 Indeks Pembangunan             [4]     │
│  ┌──────────────┬──────────────┐           │
│  │ [📈]      → │ [⚖️]       →  │           │
│  │ IPM         │ IPG          │           │
│  │ Indeks Pem- │ Indeks Pem-  │           │
│  │ bangunan... │ bangunan...  │           │
│  └──────────────┴──────────────┘           │
│  ┌──────────────┬──────────────┐           │
│  │ [📊]      → │ [🌍]      →  │           │
│  │ IDG         │ SDGs         │           │
│  │ Indeks Ke-  │ Sustainable  │           │
│  │ timpangan...│ Development..│           │
│  └──────────────┴──────────────┘           │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│  BOTTOM NAVIGATION                          │
│  ┌──────────────┬──────────────┐           │
│  │   [🏠]      │   [👤]       │           │
│  │   Home       │   Profile    │           │
│  │   (active)   │              │           │
│  └──────────────┴──────────────┘           │
└─────────────────────────────────────────────┘
```

---

## Component Specifications

### 1. Header Section
```
┌──────────────────────────────────┐
│ [🏢] BPS KOTA SEMARANG          │ ← Logo in rounded container
│      Statistik Terpercaya        │ ← Subtitle
│                                  │
│ [🔍 Cari kategori statistik...]  │ ← White search bar
└──────────────────────────────────┘
   Dark Slate Background (#475569)
   Height: ~140px with safe area
```

**Colors:**
- Background: `BPSColors.headerBg` (#475569)
- Text: White
- Search bar: White with shadow
- Icon container: White 15% opacity

---

### 2. Stats Snapshot Cards
```
┌─────────────────────────────────────┐
│  [📊]   Penduduk                   │ ← 56x56 icon container
│         1.709M  [↑ +1.2%]          │ ← Value + trend badge
│         ▁▂▃▄█                      │ ← Mini chart
└─────────────────────────────────────┘
  Card with colored border accent
  Height: 160px
  Margin: 12px horizontal
  Swipeable (4 cards total)
```

**Card Colors:**
1. **Penduduk**: Blue (#3B82F6)
2. **IPM**: Green (#74B547)
3. **Kemiskinan**: Orange (#E18939)
4. **Inflasi**: Red (#EF4444)

**Trend Badges:**
- Positive: Green background, up arrow
- Negative: Orange background, down arrow
- Format: "+1.2%" or "-0.87%"

---

### 3. Category Group Headers
```
┌────────────────────────────────┐
│ [⚙️] Indikator Ekonomi   [4]   │
└────────────────────────────────┘
  Icon: 18px in rounded container
  Title: 15px bold
  Count badge: 12px in pill
```

**3 Groups:**
1. **Economic** (⚙️ Indikator Ekonomi) - 4 items
2. **Social** (👥 Indikator Sosial) - 2 items
3. **Development** (🚀 Indeks Pembangunan) - 4 items

---

### 4. Category Cards (Grid)
```
┌─────────────────────┐
│ [📊]              → │ ← 24px icon in colored box
│                     │
│ Ekonomi             │ ← 15px bold (short label)
│ Pertumbuhan Ekonomi │ ← 11px light (full label)
└─────────────────────┘
  2-column grid
  Aspect ratio: 1.5
  Gap: 12px
  Border: 1.5px (#E2E8F0)
```

**Interaction:**
- Tap: Navigate to detail screen
- Visual: Arrow indicator on top-right
- Icon: Colored background (primary 10% opacity)

---

### 5. Bottom Navigation
```
┌──────────────┬──────────────┐
│   [🏠]      │   [👤]       │
│   Home       │   Profile    │
└──────────────┴──────────────┘
  Height: 65px + safe area
  2 tabs: Home (active) / Profile
  Active: Primary color
  Inactive: Light gray
```

**States:**
- **Active**: Primary color (#475569), weight 600
- **Inactive**: Light gray (#A0AEC0), weight 500
- Icon size: 26px
- Label size: 12px

---

## Color Usage Guide

### Primary Colors
- **Header Background**: #475569 (Dark Slate)
- **Primary Actions**: #475569 (Dark Slate)
- **Background**: #F5F7FA (Light Gray)
- **Cards**: #FFFFFF (White)

### Accent Colors (Stats & Trends)
- **Blue**: #3B82F6 (Info/Neutral)
- **Green**: #74B547 (Positive/Growth)
- **Orange**: #E18939 (Warning/Attention)
- **Red**: #EF4444 (Negative/Alert)

### Text Colors
- **Primary Text**: #2D3748 (Dark Gray)
- **Secondary Text**: #718096 (Medium Gray)
- **Label/Hint**: #A0AEC0 (Light Gray)

### UI Elements
- **Border**: #E2E8F0 (Very Light Gray)
- **Shadow**: Black 0.04-0.1 opacity

---

## Spacing System

```
4px   ▪ Minimal spacing (badge padding)
8px   ▫ Tight spacing (icon-text gap)
12px  ▫ Standard spacing (grid gaps)
16px  ▫ Comfortable spacing (card padding)
20px  ▫ Section padding (horizontal margins)
24px  ▫ Large spacing (section gaps)
32px  ▫ Extra large (major sections)
```

---

## Typography Scale

```
11px  → Small labels (full category names)
12px  → Bottom nav labels, badges
13px  → Stats card labels
14px  → Search placeholder
15px  → Category short labels, group headers
16px  → Header title
18px  → Section headers
28px  → Stats values
```

**Font Weights:**
- 400: Regular (descriptions)
- 500: Medium (labels)
- 600: Semi-bold (active states)
- 700: Bold (titles, values)
- 800: Extra bold (stats numbers)

---

## Animations

### Page Load
1. **Header**: Fade in (800ms)
2. **Content**: Slide up (800ms, eased)
3. **Stagger**: Each section slightly delayed

### Interactions
- **Tap**: Ripple effect (Material)
- **Page View**: Smooth scroll with momentum
- **Search**: Instant filter (no delay)
- **Navigation**: Standard push transition

### Duration
- Quick: 200-300ms (state changes)
- Medium: 400-600ms (transitions)
- Slow: 800-1200ms (page load)

---

## Responsive Behavior

### Portrait (Default)
- 2-column grid for categories
- Full-width stats cards
- Standard spacing

### Small Screens (<360px width)
- Reduced padding (16px → 12px)
- Smaller font sizes (scale 0.9x)
- Compact stats cards

### Large Screens (>600px width)
- Maximum content width: 600px
- Centered layout
- Increased horizontal padding

---

## Empty State

When search returns no results:

```
┌─────────────────────────────────┐
│                                 │
│          🔍                     │
│      Tidak ada hasil            │
│    Coba kata kunci lain         │
│                                 │
└─────────────────────────────────┘
  Centered in white card
  Icon: 64px gray
  Title: 16px medium
  Subtitle: 14px light
```

---

## Search States

### 1. Empty (Default)
```
┌────────────────────────────┐
│ 🔍 Cari kategori statistik...│
└────────────────────────────┘
```

### 2. Typing
```
┌────────────────────────────┐
│ 🔍 ekonomi              [×]│
└────────────────────────────┘
  Clear button appears
```

### 3. With Results
```
Jelajahi Statistik     [4 hasil]
                        ↑
                  Result count badge
```

---

## Accessibility Features

### Touch Targets
- Minimum: 48x48 dp (Material guidelines)
- Category cards: ~80x80 effective area
- Bottom nav items: Full height (65px)
- Search clear button: 48x48

### Contrast Ratios
- Header text/background: 12:1 (AAA)
- Body text/background: 8:1 (AAA)
- Secondary text/background: 4.5:1 (AA)

### Text Scaling
- Supports system font size settings
- Text wraps properly
- No fixed heights on text containers

---

## Implementation Notes

### Performance
- Lazy loading: Not needed (only 10 items)
- Caching: Categories list is static
- Rebuilds: Only on search or state change
- Animations: Hardware accelerated

### Compatibility
- Flutter 3.10+
- Material Design 3
- Android API 21+
- iOS 12+

---

## Comparison: Before vs After

### Navigation
**Before:**
```
[○○○○○○○○○○] ← Infinite scroll carousel
```

**After:**
```
[🏠 Home] [👤 Profile] ← Standard tabs
```

### Categories Display
**Before:**
```
- Penduduk (hidden in carousel)
- Pendidikan (hidden in carousel)
- Tenaga Kerja (need to scroll)
...all mixed together
```

**After:**
```
⚙️ Indikator Ekonomi [4]
  [Ekonomi] [Inflasi]
  [Tenaga Kerja] [Kemiskinan]

👥 Indikator Sosial [2]
  [Penduduk] [Pendidikan]

🚀 Indeks Pembangunan [4]
  [IPM] [IPG]
  [IDG] [SDGs]
```

### Search
**Before:**
```
[🔍 Search for data...] ← Disabled!
```

**After:**
```
[🔍 Cari kategori statistik... [×]]
     ↑ Functional with filtering
```

---

This layout provides a modern, organized, and user-friendly interface while maintaining the professional BPS brand identity.
