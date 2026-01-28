# STARA App - Governor's UI/UX Mockup
**Platform**: Android (360x800dp base, responsive)
**Design Philosophy**: Trust, Clarity, Accessibility, Speed

---

## Design Principles for Public Government App

### Core Values
1. **Trustworthy**: Official government aesthetic, not flashy
2. **Accessible**: Readable for all ages/education levels (WCAG AA compliant)
3. **Transparent**: Clear data sources, last updated timestamps
4. **Fast**: Key stats within 2 taps, offline-first
5. **Inclusive**: Bilingual (Indonesian/English), large touch targets (min 48dp)

---

## Screen 1: Home Screen (Public View)

### Layout Structure
```
┌─────────────────────────────────────┐
│ [Gov Logo] STARA Kota Semarang  [≡] │ ← Header: 64dp, #1565C0 blue
│ Statistik Resmi BPS              🔍 │
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │  📊 Ringkasan Hari Ini          │ │ ← Hero Card: 180dp
│ │  Update: 28 Jan 2026, 08:00     │ │   White card, subtle shadow
│ │                                 │ │
│ │  Populasi: 1.8 jt  📈 +2.1%    │ │
│ │  Inflasi: 3.2%     📉 -0.4%    │ │   Key metrics, large numbers
│ │  IPM: 78.5         📊 +1.2     │ │   Green ↑, Red ↓ indicators
│ └─────────────────────────────────┘ │
│                                     │
│ Kategori Statistik               → │ ← Section header: 16sp, semibold
│                                     │
│ ┌──────────┬──────────┬──────────┐ │
│ │👥       │📈       │💰       │ │ ← Icon Grid: 3 columns
│ │Penduduk │Ekonomi  │Inflasi  │ │   108dp height per row
│ │1.8 jt   │+5.2%    │3.2%     │ │   Icons 40dp, colored
│ └──────────┴──────────┴──────────┘ │
│ ┌──────────┬──────────┬──────────┐ │
│ │🎓       │🏥       │💼       │ │
│ │Pendidik.│Kemiskin.│T. Kerja │ │
│ │94.2%    │8.1%     │68.4%    │ │
│ └──────────┴──────────┴──────────┘ │
│ ┌──────────┬──────────┬──────────┐ │
│ │📊       │♀♂      │🌍       │ │
│ │IPM      │IPG/IDG  │SDGs     │ │
│ │78.5     │92.3     │75/100   │ │
│ └──────────┴──────────┴──────────┘ │
│                                     │
│ Publikasi Terbaru                → │
│ ┌─────────────────────────────────┐ │
│ │ 📄 Statistik Semarang 2025      │ │ ← List: 72dp per item
│ │    20 Jan 2026 • PDF • 2.4 MB  │ │   Icons, metadata
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ 📄 Laporan Inflasi Q4 2025      │ │
│ │    15 Jan 2026 • PDF • 1.8 MB  │ │
│ └─────────────────────────────────┘ │
│                                     │
│         [Lihat Semua Publikasi]    │ ← Button: outlined, 48dp
└─────────────────────────────────────┘
│     [Beranda]  [Data]  [Info]      │ ← Bottom Nav: 56dp, 3 tabs
└─────────────────────────────────────┘
```

### Color Palette (Government Official)
- **Primary**: #1565C0 (Trust blue - Indonesian govt standard)
- **Secondary**: #2E7D32 (Growth green)
- **Alert**: #C62828 (Decline red)
- **Background**: #F5F5F5 (Soft grey)
- **Cards**: #FFFFFF (Pure white)
- **Text Primary**: #212121 (Near black)
- **Text Secondary**: #757575 (Medium grey)

### Typography
- **Headers**: Poppins Bold 20sp
- **Body**: Poppins Regular 14sp
- **Captions**: Poppins Regular 12sp
- **Numbers**: Poppins SemiBold 24sp (emphasis on data)
- **Minimum**: 14sp for accessibility

---

## Screen 2: Detail View (e.g., Population Statistics)

### Layout Structure
```
┌─────────────────────────────────────┐
│ ← Penduduk Kota Semarang        [⋮] │ ← AppBar: Back + Menu
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │  1,847,056 jiwa                 │ │ ← Stat Card: 120dp
│ │  Total Populasi 2025            │ │   Huge number (32sp)
│ │  ↗ +2.1% dari 2024              │ │   Trend indicator
│ │  📅 Update: 1 Jan 2026          │ │   Source timestamp
│ └─────────────────────────────────┘ │
│                                     │
│ [Grafik] [Tabel] [Unduh]           │ ← Tab selector: 48dp
│ ────────                            │
│                                     │
│ Trend Populasi 5 Tahun             │ ← Chart section: 280dp
│ ┌─────────────────────────────────┐ │
│ │        ·························│ │   Line chart
│ │       ··                        │ │   Interactive, tooltips
│ │      ·                          │ │   Clean gridlines
│ │     ·                           │ │   Large tap targets
│ │    ·                            │ │
│ │ 2020  2021  2022  2023  2024   │ │
│ │ 1.75M 1.78M 1.80M 1.82M 1.85M  │ │   Data labels below
│ └─────────────────────────────────┘ │
│                                     │
│ Distribusi Usia                    │
│ ┌─────────────────────────────────┐ │
│ │ 0-14 tahun:  ████████  22.3%   │ │ ← Horizontal bars
│ │ 15-64 tahun: ████████████ 68.1%│ │   with percentages
│ │ 65+ tahun:   ███  9.6%         │ │   Color-coded
│ └─────────────────────────────────┘ │
│                                     │
│ Kepadatan Penduduk                 │
│ ┌─────────────────────────────────┐ │
│ │  4,812 jiwa/km²                 │ │ ← Info cards
│ │  Luas wilayah: 384 km²          │ │   Simple, scannable
│ └─────────────────────────────────┘ │
│                                     │
│ ℹ Sumber Data                       │
│ Badan Pusat Statistik Kota Semarang│ ← Attribution: 12sp
│ Diolah: 28 Jan 2026, 08:00 WIB     │   Light grey text
│                                     │
└─────────────────────────────────────┘
```

### Interaction Patterns
1. **Chart Tap**: Show tooltip with exact value
2. **Long Press**: Copy data value
3. **Swipe Left/Right**: Navigate between years
4. **Pull to Refresh**: Update latest data
5. **Share Button**: Export as image/PDF

---

## Screen 3: Search/Discovery

### Layout Structure
```
┌─────────────────────────────────────┐
│ ← Pencarian Data                    │
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 🔍 Cari statistik...        [×] │ │ ← Search bar: 56dp
│ └─────────────────────────────────┘ │   Auto-suggest enabled
│                                     │
│ Pencarian Populer                  │ ← Quick filters
│ [#Inflasi] [#IPM] [#Kemiskinan]    │   Chips: 32dp height
│                                     │
│ Hasil (23)                         │
│ ┌─────────────────────────────────┐ │
│ │ 📊 Inflasi 2025                 │ │ ← Result cards: 88dp
│ │ Kategori: Inflasi • 3.2%        │ │   Icon + title + meta
│ │ Update: 15 Jan 2026             │ │   Tap to open detail
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ 👥 Populasi Usia Produktif      │ │
│ │ Kategori: Penduduk • 68.1%      │ │
│ │ Update: 1 Jan 2026              │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Filter                             │
│ [Kategori ▼] [Tahun ▼] [Urutkan ▼]│ ← Filter bar: 48dp
│                                     │
└─────────────────────────────────────┘
```

---

## Screen 4: Settings/Info

### Layout Structure
```
┌─────────────────────────────────────┐
│ ← Informasi & Pengaturan            │
├─────────────────────────────────────┤
│                                     │
│ Preferensi                         │
│ ┌─────────────────────────────────┐ │
│ │ Bahasa           Indonesia    ▼ │ │ ← Settings list: 56dp
│ │ Tema             Terang       ▼ │ │   items
│ │ Notifikasi       Aktif        ⚫ │ │   Toggle switches
│ └─────────────────────────────────┘ │
│                                     │
│ Tentang Aplikasi                   │
│ ┌─────────────────────────────────┐ │
│ │ 🏛️ STARA v1.0.0                 │ │
│ │ Badan Pusat Statistik           │ │
│ │ Kota Semarang                   │ │
│ │                                 │ │
│ │ [Website BPS]  [Hubungi Kami]  │ │ ← Action buttons
│ └─────────────────────────────────┘ │
│                                     │
│ Data & Privasi                     │
│ ┌─────────────────────────────────┐ │
│ │ [Kebijakan Privasi]             │ │
│ │ [Syarat Penggunaan]             │ │
│ │ [Lisensi Open Data]             │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Penyimpanan                        │
│ ┌─────────────────────────────────┐ │
│ │ Data tersimpan: 24.8 MB         │ │
│ │ [Hapus Cache] [Unduh Offline]  │ │
│ └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

---

## Key UX Improvements for Public Use

### 1. Accessibility First
- **Font Scaling**: Support Android accessibility settings (up to 200%)
- **High Contrast Mode**: Alternative color scheme for vision impairment
- **Screen Reader**: Full TalkBack support with descriptive labels
- **Touch Targets**: Minimum 48x48dp for all interactive elements
- **Color Blind Safe**: Use patterns + colors in charts

### 2. Data Clarity
- **Progressive Disclosure**: Show summary first, drill down for details
- **Visual Hierarchy**: Large numbers for key stats, supporting text smaller
- **Context Always**: Show what number means ("8.1% tingkat kemiskinan")
- **Trends**: Always show direction (↑↓) and comparison period
- **Plain Language**: Avoid jargon, explain technical terms

### 3. Trust Indicators
- **Official Branding**: BPS logo, government color scheme
- **Data Source**: Always visible on every screen
- **Timestamps**: "Last updated" on all data points
- **Verification**: "Data Resmi BPS" badge
- **Contact Info**: Easy access to ask questions

### 4. Performance
- **Offline First**: All viewed data cached, works without internet
- **Fast Load**: Skeleton screens, no blank states
- **Image Optimization**: Vector icons, compressed images
- **Data Sync**: Background sync when online, no blocking

### 5. Inclusivity
- **Bilingual**: Indonesian primary, English option
- **Multiple Formats**: Charts, tables, text explanations
- **Export Options**: PDF, Excel, Share as image
- **Voice Search**: For accessibility
- **Simple Language**: Grade 8 reading level

---

## Navigation Flow

```
Home → Category → Detail → Export/Share
  ↓       ↓         ↓
Search  Filter   Compare (2+ datasets)
  ↓       ↓         ↓
Info   Settings  Publications
```

---

## Widget Specifications

### Stat Card Component
```dart
Container(
  padding: 16.dp,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: 12.dp,
    boxShadow: [elevation: 2.dp],
  ),
  child: Column(
    children: [
      Text("1,847,056",
        style: Poppins.Bold.32sp.primaryColor),
      Text("Total Populasi 2025",
        style: Poppins.Regular.14sp.grey700),
      Row(
        Icon(trending_up, color: green),
        Text("+2.1% dari 2024",
          style: Poppins.Medium.12sp.green),
      ),
    ],
  ),
)
```

### Category Grid Item
```dart
Card(
  height: 108.dp,
  width: 108.dp,
  child: Column(
    Icon(category_icon, size: 40.dp, color: primary),
    Text("Penduduk",
      style: Poppins.Medium.14sp,
      maxLines: 2,
      overflow: ellipsis),
    Text("1.8 jt",
      style: Poppins.SemiBold.16sp.primary),
  ),
)
```

---

## Why This Design for Public Government App?

### ✅ Trust
- Official government blue (#1565C0)
- BPS branding prominent
- Source attribution everywhere
- No ads, no tracking indicators

### ✅ Accessibility
- Large text (min 14sp)
- High contrast (4.5:1 ratio)
- Simple language
- Multiple format options

### ✅ Speed
- Key stats on home (no search needed)
- Offline-first architecture
- Minimal taps to data (2 max)
- Fast load with skeleton screens

### ✅ Transparency
- Timestamps on all data
- Clear methodology links
- Contact info accessible
- Open data export

### ✅ Universal Design
- Works for elderly (large text, simple layout)
- Works for students (search, explanations)
- Works for researchers (export, raw data)
- Works for media (share, embeddable charts)

---

## Implementation Priority

**Phase 1 (MVP)**:
- Home screen with hero stats
- Category grid navigation
- Detail screens with basic charts
- Offline storage

**Phase 2**:
- Search & filters
- Advanced charts (interactive)
- Export/share features
- Notifications for new data

**Phase 3**:
- Bilingual support
- Compare mode
- Voice search
- Accessibility enhancements

---

## Success Metrics

1. **Adoption**: 50k+ downloads in 3 months
2. **Engagement**: 60%+ users return weekly
3. **Satisfaction**: 4.5+ rating on Play Store
4. **Accessibility**: 90%+ accessibility score
5. **Performance**: <2s load time, offline capable

---

**Design Motto**: "Data untuk Semua, Akses untuk Semua"
(Data for Everyone, Access for Everyone)
