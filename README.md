# ⚡ QuickSlot — Sports Slot Booking App

A full-stack mobile application for booking sports venue slots (badminton courts, football turfs, tennis courts). Users browse venues, pick a date, view hourly time slots, and book — with **concurrency-safe booking** that prevents double-bookings even when two users tap "Book" on the same slot at the same instant.

---

## 🏗️ Architecture

### Backend — Python / Django REST Framework

```
backend_code/server/
├── quickslot/          # Django project settings, URL config, WSGI
├── bookings/
│   ├── models.py       # User, Venue, Slot, Booking (PostgreSQL)
│   ├── views.py        # REST API views (DRF APIView)
│   ├── services.py     # BookingService — atomic, concurrency-safe logic
│   ├── serializers.py  # DRF serializers (full + minimal variants)
│   ├── middleware.py    # Firebase Auth token verification middleware
│   ├── urls.py         # API route definitions
│   ├── tests.py        # 10 unit tests (booking, conflict, cancel, polling)
│   └── management/commands/seed.py  # Seeds 5 venues + 7 days of slots
├── Dockerfile          # Production container image
├── docker-compose.yml  # One-command local setup (Postgres + Django)
├── render.yaml         # Render.com deployment blueprint
└── requirements.txt    # Python dependencies
```

**Tech stack**: Python 3.12 · Django 5 · Django REST Framework · PostgreSQL · Firebase Admin SDK · Gunicorn · WhiteNoise · Docker

### Flutter App — BLoC + MVVM (Clean Architecture)

```
flutter_app/lib/
├── core/
│   ├── constants/      # API endpoints, app-wide constants
│   ├── network/        # Dio HTTP client with interceptors, custom exceptions
│   ├── theme/          # Dark theme with Google Fonts (Outfit)
│   └── utils/          # Logger, date formatting utilities
├── data/
│   ├── models/         # Equatable data models with fromJson/toJson
│   ├── datasources/    # Remote (API) + Local (SharedPreferences) data sources
│   └── repositories/   # Repository pattern — single source of truth
├── presentation/
│   ├── blocs/          # 4 BLoCs: Auth, Venue, Slot, Booking
│   ├── screens/        # 6 screens: Login, Register, Home, VenueList, VenueDetail, MyBookings
│   └── widgets/        # Reusable: VenueCard, SlotTile, SlotGrid, BookingCard, Loading/Error/Empty
└── main.dart           # App entry point, Firebase init, provider tree
```

**Tech stack**: Flutter 3.x · Dart 3.x · flutter_bloc (BLoC pattern) · Equatable · Dio · Firebase Auth · Google Sign-In · SharedPreferences · Google Fonts · Shimmer · Staggered Animations · CachedNetworkImage

**State management**: **BLoC** — chosen for its strict unidirectional data flow (Event → Bloc → State), clear separation of business logic from UI, and excellent testability. Each feature (auth, venues, slots, bookings) has its own Bloc with well-defined events and states, making the codebase easy to reason about and extend.

**MVVM mapping**: Models = `data/models/`, ViewModels = `presentation/blocs/`, Views = `presentation/screens/` + `presentation/widgets/`. Repositories bridge the data and presentation layers.

---

## 🔒 Concurrency — The Double-Booking Problem

This is the core hard requirement. Two layers of defense:

1. **`SELECT ... FOR UPDATE` (row-level DB lock)** — Inside `@transaction.atomic`, `Slot.objects.select_for_update()` acquires a PostgreSQL row lock. If User A and User B try to book the same slot simultaneously, one blocks until the other's transaction commits. The second user then sees `is_booked = True` and gets a `409 Conflict`.

2. **`OneToOneField(Slot → Booking)` (DB unique constraint)** — Even if the application-level check is somehow bypassed, PostgreSQL enforces a UNIQUE constraint on `slot_id` in the `bookings_booking` table. A duplicate insert raises `IntegrityError`, which the view catches and returns `409`.

**Flutter side**: The app catches `409` as a `SlotAlreadyBookedException`, shows a "⚠️ Slot Unavailable" dialog, and auto-refreshes the slot grid.

---

## 🚀 Setup & Run

### Prerequisites

- Python 3.12+, PostgreSQL, Flutter SDK (3.x), Android emulator or physical device
- Firebase project with Auth enabled (Email/Password + Google Sign-In)

### Backend

```bash
# 1. Navigate to backend
cd backend_code/server

# 2. Create virtual environment & install dependencies
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 3. Create local PostgreSQL database
createdb quickslot

# 4. Copy and configure environment
cp .env.example .env   # Edit DATABASE_URL and FIREBASE_CREDENTIALS_PATH

# 5. Run migrations & seed data
python manage.py migrate
python manage.py seed

# 6. Start dev server
python manage.py runserver 0.0.0.0:8000
```

**Or with Docker (one command):**
```bash
cd backend_code/server
docker compose up --build
# API available at http://localhost:8000/api/
```

### Flutter App

```bash
cd flutter_app

# Install dependencies
flutter pub get

# Run on Android emulator (default — uses 10.0.2.2:8000)
flutter run

# Run on physical device (replace with your machine's LAN IP)
flutter run --dart-define=API_BASE_URL=http://192.168.x.x:8000/api

# Run against deployed Render backend
flutter run --dart-define=API_BASE_URL=https://quickslot-api.onrender.com/api
```

---

## 📡 API Endpoints

| Method | Endpoint | Description | Status Codes |
|--------|----------|-------------|--------------|
| `GET` | `/api/venues/` | List all venues | 200 |
| `GET` | `/api/venues/{id}/slots/?date=YYYY-MM-DD` | Slots for a venue on a date | 200, 400, 404 |
| `POST` | `/api/bookings/` | Book a slot `{"slot_id": N}` | 201, 400, 409 |
| `GET` | `/api/me/bookings/` | Current user's bookings | 200 |
| `DELETE` | `/api/bookings/{id}/` | Cancel a booking | 204, 403, 404 |
| `POST` | `/api/auth/sync/` | Sync Firebase user to backend | 200 |
| `GET` | `/api/venues/{id}/slots/poll/?date=...&since=...` | Delta polling for slot changes | 200 |

**Auth**: All endpoints require `Authorization: Bearer <firebase_id_token>`. The middleware verifies the token with Firebase Admin SDK and auto-creates/updates the user record.

> **Note**: The spec suggests `GET /users/{id}/bookings` but we use `GET /api/me/bookings/` instead — the user is derived from the auth token, preventing users from viewing each other's bookings.

---

## ✅ Bonus Features (5/5 + Google Sign-In)

| # | Bonus | Implementation |
|---|-------|---------------|
| 1 | **Slot status updates via polling** | 10-second `Timer.periodic` in `SlotBloc` silently refreshes slots; backend has a dedicated `/slots/poll/` delta endpoint with `since` timestamp |
| 2 | **Offline read cache for My Bookings** | `BookingLocalDataSource` uses `SharedPreferences` to cache bookings as JSON; `BookingRepository` returns cached data when network fails |
| 3 | **Unit tests for booking logic** | 10 Django tests: booking success, double-booking conflict (app + DB level), past-slot rejection, cancel, cross-user cancel block, slot polling |
| 4 | **Dockerized backend** | `Dockerfile` (Python 3.12-slim + Gunicorn) + `docker-compose.yml` (Postgres 16 + Django) — `docker compose up` runs everything |
| 5 | **Filter slots by time of day** | `_TimeFilter` enum (All / Morning / Afternoon / Evening) with `FilterChip` row on venue detail screen |
| 🎁 | **Google Sign-In** | Full OAuth flow: `google_sign_in` → Firebase credential → backend sync. Works alongside email/password auth |

---

## ✂️ What We Cut & Why

- **Full auth system** — The spec says "hardcoded users + X-User-Id is acceptable". We went with Firebase Auth instead (more impressive, real-world pattern), but kept it lightweight — no forgot-password, no profile editing.
- **Venue images** — Using Unsplash URLs from seed data rather than user-uploaded images. Sufficient for demo.
- **Payment integration** — Out of scope for a 6-hour hackathon. Price is displayed but no actual payment.
- **Push notifications** — Polling is used instead of WebSockets/FCM for real-time updates. Pragmatic choice given time constraints.

---

## 🔮 What We'd Do With One More Day

1. **WebSocket-based real-time updates** — Replace polling with Django Channels for instant slot status sync across devices
2. **Widget tests & integration tests** — Test the slot grid, booking flow, and conflict dialog in Flutter
3. **Search & filter venues** — By sport type, location, price range
4. **Booking history with past bookings** — Separate past/upcoming sections
5. **Rate limiting** — Prevent API abuse on booking endpoint
6. **Venue images upload** — Allow admins to upload venue photos

---

## 🤖 AI Usage Note

**Tools used**: [Antigravity](https://deepmind.google/) (Google DeepMind's agentic coding assistant) and Claude Code were used throughout development for:

- Scaffolding the project structure (BLoC + MVVM folder layout, Django app structure)
- Writing boilerplate code (models, serializers, BLoC events/states, Dio interceptors)
- Implementing the concurrency-safe booking service (`select_for_update` + `@transaction.atomic`)
- Designing the dark theme and UI components
- Writing backend unit tests
- Debugging Firebase auth integration and serializer mismatches

**One thing AI got wrong that I caught and fixed**: The AI-generated `SlotModel.fromJson()` in the Flutter app used `json['venue']` to parse the venue ID, but the Django REST Framework serializer was returning the field as `venue_id` (because it was defined with `source='venue.id'`). This would have caused a silent `null` value for `venueId` on every slot, breaking the slot grid. Similarly, `UserModel.fromJson()` read `json['uid']` but the backend serializer returned `firebase_uid`. I caught these during end-to-end testing when the slot grid loaded but venue associations were wrong, and fixed both the Flutter model keys and expanded the backend's minimal serializers to include all fields the app needs.

---

## 📋 Commit History

27 commits with meaningful messages, committed incrementally throughout development:

```
feat(app): scaffold Flutter project with BLoC + MVVM folder structure
feat(server): scaffold Django project with models, views, seed data
feat(app): add core layer with dark theme, Dio API client, and custom exceptions
feat(app): add data models, remote data sources, and repositories
feat(app): add Firebase Auth with login/register screens and Auth BLoC
feat(app): add venue list screen with venue BLoC and animated cards
feat(app): add venue detail with date picker, slot grid, booking flow
feat(app): add my bookings screen with cancel flow and empty state
feat(app): add loading shimmer, error, and empty states with animations
feat(server): add slot polling endpoint with since parameter
feat(server): add Docker config and booking concurrency tests
feat(app): add time-of-day filter for slots on venue detail screen
feat(app): wire slot polling to delta endpoint
feat(app): add debug logger, Google Sign-In, API error handling
feat(app): offline read cache for My Bookings via SharedPreferences
...
```

---

## 📝 License

Built for the Swades QuickSlot Hiring Hackathon. Not for production use.
