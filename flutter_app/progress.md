# QuickSlot Flutter — Progress

## Phase F0 — Project Scaffolding ✅
- [x] Flutter project created with `flutter create`
- [x] MVVM + BLoC folder structure set up
- [x] Dependencies configured in pubspec.yaml
- [x] Firebase linked via `flutterfire configure`

## Phase F1 — Core Layer ✅
- [x] Dark theme with glassmorphism (AppTheme)
- [x] API constants (base URL, timeouts)
- [x] Dio API client with Firebase auth interceptor
- [x] Custom exceptions (ApiException, SlotAlreadyBooked, Unauthorized, Network)

## Phase F2 — Data Layer ✅
- [x] Models: User, Venue, Slot, Booking (with JSON serialization)
- [x] Remote data sources: Auth, Venue, Booking
- [x] Repositories: Auth, Venue, Booking

## Phase F3 — Firebase Auth ✅
- [x] Auth BLoC (login, register, logout, check status)
- [x] Login screen with form validation
- [x] Register screen with form validation
- [x] Auth state management + error handling

## Phase F4 — Venue List Screen ✅
- [x] Venue BLoC (fetch venues)
- [x] Venue cards with staggered animations
- [x] Home screen with bottom navigation (Venues ↔ Bookings)
- [x] Pull-to-refresh

## Phase F5 — Venue Detail Screen ✅
- [x] Slot BLoC (fetch slots, book slot, select slot)
- [x] Horizontal date picker (today + 6 days)
- [x] Slot grid (4 columns, available/booked/selected states)
- [x] Booking flow with confirmation bottom sheet
- [x] 409 conflict handling dialog

## Phase F6 — My Bookings Screen ✅
- [x] Booking BLoC (fetch bookings, cancel booking)
- [x] Booking cards with venue info and cancel button
- [x] Cancel confirmation dialog
- [x] Empty state

## Phase F7 — Polish ✅
- [x] Shimmer loading widgets (venue list, slot grid, bookings)
- [x] Error widget with retry button
- [x] Empty state widget with action button
- [x] Staggered entry animations

## Bonus Phases
- [ ] F8: Google Sign-In (dependency added, not implemented)
- [ ] F9: Slot Polling (auto-refresh every 10s)
- [ ] F10: Offline Cache + BLoC Tests
