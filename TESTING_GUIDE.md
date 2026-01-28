# Home Screen Redesign - Testing Guide

## Quick Testing Checklist

### ✅ Pre-Flight Check
Before testing, ensure:
- [ ] Flutter is running (`flutter run`)
- [ ] Hot reload works (press `r` in terminal)
- [ ] No compile errors
- [ ] Assets are available (`assets/images/logo.png`)

---

## 1. Header & Search Testing

### Test: Header Display
**Steps:**
1. Launch the app
2. Observe the header section

**Expected:**
- ✅ BPS logo appears in rounded container
- ✅ "BPS KOTA SEMARANG" title in white
- ✅ "Statistik Terpercaya" subtitle below
- ✅ Dark slate background (#475569)
- ✅ Smooth fade-in animation

### Test: Search Functionality
**Steps:**
1. Tap the search bar
2. Type "ekonomi"
3. Observe results
4. Clear search with X button
5. Type gibberish like "xyz123"

**Expected:**
- ✅ Keyboard appears when tapped
- ✅ Results filter instantly as you type
- ✅ "4 hasil" badge appears for "ekonomi"
- ✅ Clear button (×) appears when typing
- ✅ Categories filter correctly
- ✅ Empty state appears for no results
- ✅ All categories return when cleared

**Test Cases:**
| Search Query | Expected Results |
|--------------|------------------|
| "ekonomi" | 1 result (Pertumbuhan Ekonomi) |
| "penduduk" | 1 result (Penduduk) |
| "ipm" | 1 result (IPM) |
| "inflasi" | 1 result (Inflasi) |
| "indeks" | 3 results (IPM, IPG, IDG) |
| "xyz" | Empty state |

---

## 2. Stats Snapshot Testing

### Test: Swipeable Cards
**Steps:**
1. Scroll to stats section
2. Swipe left through all 4 cards
3. Swipe right to go back
4. Tap on each card

**Expected:**
- ✅ 4 cards appear: Penduduk, IPM, Kemiskinan, Inflasi
- ✅ Smooth swipe animation
- ✅ Page indicators update (4 dots)
- ✅ Active dot is elongated (24px)
- ✅ Inactive dots are small (8px)
- ✅ Each card navigates to correct screen

### Test: Card Data Display
**Verify each card shows:**
- ✅ Icon in colored container
- ✅ Category label
- ✅ Large value number
- ✅ Trend badge with percentage
- ✅ Up/down arrow in badge
- ✅ Mini line chart
- ✅ Proper color coding

**Card Details:**
1. **Penduduk**: Blue, 1.709M, +1.2%, up arrow
2. **IPM**: Green, 82.39, +2.3%, up arrow
3. **Kemiskinan**: Orange, 4.03%, -0.87%, down arrow
4. **Inflasi**: Red, 2.89%, +0.39%, up arrow

---

## 3. Category Grid Testing

### Test: Group Headers
**Steps:**
1. Scroll down to categories section
2. Observe the 3 group headers

**Expected:**
- ✅ "⚙️ Indikator Ekonomi [4]" appears first
- ✅ "👥 Indikator Sosial [2]" appears second
- ✅ "🚀 Indeks Pembangunan [4]" appears third
- ✅ Icons have colored backgrounds
- ✅ Count badges show correct numbers

### Test: Category Cards Layout
**Steps:**
1. Observe the grid layout
2. Scroll through all categories
3. Check spacing and alignment

**Expected:**
- ✅ 2-column grid layout
- ✅ Consistent card sizes
- ✅ 12px gaps between cards
- ✅ All 10 categories visible
- ✅ Cards have border and shadow
- ✅ Icons in colored containers
- ✅ Arrow indicators on cards

### Test: Category Navigation
**Tap each card and verify navigation:**

**Economic Group:**
- [ ] Ekonomi → PertumbuhanEkonomiScreen
- [ ] Inflasi → InflasiScreen
- [ ] Ketenagakerjaan → TenagaKerjaScreen
- [ ] Kemiskinan → KemiskinanScreen

**Social Group:**
- [ ] Penduduk → PendudukScreen
- [ ] Pendidikan → PendidikanScreen

**Development Group:**
- [ ] IPM → IpmScreen
- [ ] IPG → IPGScreen
- [ ] IDG → IDGScreen
- [ ] SDGs → UserSDGsScreen

---

## 4. Bottom Navigation Testing

### Test: Tab Switching
**Steps:**
1. Observe bottom navigation
2. Tap "Profile" tab
3. Return and tap "Home" tab

**Expected:**
- ✅ 2 tabs visible: Home, Profile
- ✅ Home tab active by default (dark color)
- ✅ Profile tab inactive (light gray)
- ✅ Tapping Profile navigates to ProfileScreen
- ✅ Returns to Home on back press
- ✅ Active state updates correctly

### Test: Visual Feedback
**Expected:**
- ✅ Icons: 26px size
- ✅ Active: Primary color (#475569)
- ✅ Inactive: Light gray (#A0AEC0)
- ✅ Labels: 12px font
- ✅ Ripple effect on tap
- ✅ Shadow above nav bar

---

## 5. Responsive & Scroll Testing

### Test: Scrolling Behavior
**Steps:**
1. Scroll from top to bottom
2. Scroll back to top
3. Perform fast fling scroll

**Expected:**
- ✅ Smooth scroll throughout
- ✅ No jank or stuttering
- ✅ Stats cards scroll horizontally
- ✅ Main content scrolls vertically
- ✅ Bottom nav stays fixed
- ✅ Header scrolls with content

### Test: Content Overflow
**Steps:**
1. Observe text in category cards
2. Check long category names

**Expected:**
- ✅ Text wraps properly (max 2 lines)
- ✅ Ellipsis (...) for overflow
- ✅ No text cutoff
- ✅ Full label appears below short label

---

## 6. Animation Testing

### Test: Page Load Animation
**Steps:**
1. Force app restart (hot restart: `R`)
2. Observe animations on load

**Expected:**
- ✅ Header fades in smoothly
- ✅ Content slides up from bottom
- ✅ Total duration ~800ms
- ✅ Eased animation curve
- ✅ No jerky motion

### Test: Interaction Animations
**Expected:**
- ✅ Tap ripple on all tappable items
- ✅ Page view swipe has momentum
- ✅ Search filtering is instant (no animation)
- ✅ Navigation transition is standard

---

## 7. Edge Cases

### Test: Empty Search Results
**Steps:**
1. Type "asdfghjkl" in search
2. Observe empty state

**Expected:**
- ✅ Large search-off icon (64px)
- ✅ "Tidak ada hasil" message
- ✅ "Coba kata kunci lain" hint
- ✅ White card container
- ✅ Centered layout

### Test: Search with Spaces
**Steps:**
1. Type " inflasi " (with spaces)
2. Observe results

**Expected:**
- ✅ Search works despite spaces
- ✅ Case insensitive matching

### Test: Rapid Tab Switching
**Steps:**
1. Quickly tap Home → Profile → Home → Profile

**Expected:**
- ✅ No crash
- ✅ Navigation works correctly
- ✅ State updates properly

---

## 8. Visual Quality Check

### Colors Verification
Open the app and verify colors match:
- [ ] Header: Dark slate (#475569)
- [ ] Background: Light gray (#F5F7FA)
- [ ] Cards: Pure white (#FFFFFF)
- [ ] Primary text: Dark gray (#2D3748)
- [ ] Secondary text: Medium gray (#718096)
- [ ] Labels: Light gray (#A0AEC0)

### Typography Verification
Check font sizes are readable:
- [ ] Header title: 16px
- [ ] Section headers: 18px
- [ ] Category labels: 15px
- [ ] Stats values: 28px
- [ ] Small text: 11px minimum

### Spacing Verification
Check consistent spacing:
- [ ] Card padding: 16-20px
- [ ] Section margins: 20px horizontal
- [ ] Grid gaps: 12px
- [ ] Vertical sections: 24-32px apart

---

## 9. Performance Testing

### Test: Scroll Performance
**Steps:**
1. Scroll rapidly up and down
2. Monitor frame rate

**Expected:**
- ✅ 60 FPS maintained
- ✅ No dropped frames
- ✅ Smooth animations

### Test: Search Performance
**Steps:**
1. Type rapidly in search bar
2. Observe UI responsiveness

**Expected:**
- ✅ Instant filtering (<16ms)
- ✅ No lag while typing
- ✅ Smooth result updates

---

## 10. Accessibility Testing

### Test: Touch Targets
**Steps:**
1. Tap all interactive elements
2. Try tapping edges of cards

**Expected:**
- ✅ All taps register accurately
- ✅ Minimum 48dp touch area
- ✅ No accidental taps
- ✅ Ripple feedback on all taps

### Test: Text Readability
**Steps:**
1. View app in bright sunlight (or simulate)
2. Read all text on screen

**Expected:**
- ✅ All text clearly readable
- ✅ Good contrast ratios
- ✅ No eye strain
- ✅ Icons recognizable

---

## Known Issues to Watch For

### Potential Issues:
1. **Logo not found**: If `assets/images/logo.png` missing
2. **Search lag**: On very old devices
3. **PageView stuttering**: If device has limited RAM
4. **Text overflow**: On very small screens (<320px)

### Solutions:
1. Ensure assets path in `pubspec.yaml`
2. Test on real device, not just emulator
3. Clear Flutter cache: `flutter clean && flutter pub get`
4. Check Flutter version: `flutter doctor`

---

## Regression Testing

Verify old functionality still works:
- [ ] All 10 category screens load correctly
- [ ] Data displays properly in detail screens
- [ ] Back navigation works from all screens
- [ ] Profile screen accessible
- [ ] Charts render in detail screens
- [ ] No console errors or warnings

---

## Test Report Template

```
Date: [Date]
Tester: [Name]
Device: [Device Model]
OS Version: [iOS/Android Version]
Flutter Version: [Version]

Test Results:
✅ Header & Search: PASS / FAIL
✅ Stats Snapshot: PASS / FAIL
✅ Category Grid: PASS / FAIL
✅ Bottom Nav: PASS / FAIL
✅ Animations: PASS / FAIL
✅ Performance: PASS / FAIL
✅ Accessibility: PASS / FAIL

Issues Found:
1. [Description]
2. [Description]

Screenshots:
- [Attach screenshots of any issues]

Notes:
[Any additional observations]
```

---

## Automated Testing (Optional)

If you want to add widget tests, here's what to test:

```dart
testWidgets('Search filters categories', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.enterText(find.byType(TextField), 'ekonomi');
  await tester.pump();

  expect(find.text('4 hasil'), findsOneWidget);
});

testWidgets('Stats cards are swipeable', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.drag(find.byType(PageView).first, Offset(-300, 0));
  await tester.pumpAndSettle();

  // Verify page indicator changed
});

testWidgets('Category cards navigate correctly', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.text('Ekonomi'));
  await tester.pumpAndSettle();

  expect(find.byType(PertumbuhanEkonomiScreen), findsOneWidget);
});
```

---

## Success Criteria

The redesign is successful if:
- ✅ All 10 categories are easily accessible
- ✅ Search works and is useful
- ✅ Navigation is intuitive
- ✅ No UX confusion or frustration
- ✅ Performance is smooth (60fps)
- ✅ Visually appealing and professional
- ✅ All original features work
- ✅ No regressions introduced

---

## Next Steps After Testing

1. **If issues found**: Document and fix
2. **If all passes**: Deploy to production
3. **Gather feedback**: Ask users for opinions
4. **Iterate**: Make improvements based on feedback
5. **Monitor**: Track usage analytics

---

Good luck with testing! 🚀
