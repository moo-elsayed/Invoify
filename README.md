<div align="center">

# 📄 Invoify

### Automated Invoicing & Payment Tracking — B2B SaaS Mobile App

[![Flutter CI/CD](https://img.shields.io/github/actions/workflow/status/moo-elsayed/Invoify/flutter_ci.yml?label=Flutter%20CI%2FCD&logo=flutter&logoColor=white&color=02569B)](https://github.com/moo-elsayed/Invoify/actions/workflows/flutter_ci.yml)
[![Backend CI/CD](https://img.shields.io/github/actions/workflow/status/moo-elsayed/Invoify/backend_ci.yml?label=Backend%20CI%2FCD&logo=firebase&logoColor=white&color=FFCA28)](https://github.com/moo-elsayed/Invoify/actions/workflows/backend_ci.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore%20%7C%20Auth%20%7C%20FCM-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Stripe](https://img.shields.io/badge/Payments-Stripe-635BFF?logo=stripe&logoColor=white)](https://stripe.com)
[![TypeScript](https://img.shields.io/badge/Backend-TypeScript-3178C6?logo=typescript&logoColor=white)](https://www.typescriptlang.org)

> **Invoify** empowers freelancers and small business owners to create professional invoices, automate client follow-ups, and collect payments — all from their mobile device, fully automated.

</div>

---

## ✨ What is Invoify?

Invoify is a **full-stack B2B SaaS mobile application** built with Flutter and Firebase. It handles the entire invoice lifecycle — from creation and PDF generation to email delivery and payment confirmation — with zero manual follow-up required.

```
Draft → Pending → [Email Opened] → Overdue → Paid ✅
```

Everything in between is **automated**.

---

## 🚀 Key Features

### 📱 Mobile App (Flutter)

| Feature | Description |
|---|---|
| 🔐 **Authentication** | Email/Password + Google Sign-In with persistent sessions |
| 👥 **Client Management** | Full CRUD — add, edit, delete, and view clients |
| 🧾 **Invoice Creation** | Dynamic line items with auto-calculated totals, tax & discounts |
| 📊 **Dashboard & Analytics** | Charts for monthly earnings, overdue amounts & top clients |
| 🔔 **Push Notification Routing** | Tap a notification → land directly on the invoice screen |
| 🌍 **Localization** | Full Arabic & English support (RTL-ready) |
| 🎨 **Theming** | Light & Dark mode with user preference persistence |
| 💱 **Multi-Currency** | Configurable per-user currency (USD, EGP, etc.) |

### ⚙️ Backend (Cloud Functions — Node.js / TypeScript)

| Function | Trigger | What it does |
|---|---|---|
| **PDF Generator** | Invoice → `pending` | Generates a professional, Arabic-ready PDF and uploads it to Firebase Storage |
| **Stripe Checkout** | Firestore trigger | Creates a payment link and updates the invoice document |
| **Invoice Emailer** | After PDF + link ready | Sends the client a branded email with PDF attached and payment link included |
| **Email Tracking Pixel** | Client opens email | Updates invoice status to `opened` with a timestamp |
| **Stripe Webhook** | Payment confirmed | Marks invoice as `paid`, fires FCM push notification instantly |
| **Daily Cron Job** | Every day at 9:00 AM | Scans overdue invoices, updates statuses, sends automated follow-up emails |

---

## 🏗️ Architecture & Tech Stack

```
invoify/
├── lib/
│   ├── core/                  # Shared utilities (routing, theming, services, DI)
│   │   ├── constants/
│   │   ├── routing/           # GoRouter + deep linking
│   │   ├── theming/           # Light/Dark themes
│   │   ├── services/          # FCM, notifications, etc.
│   │   └── widgets/           # Reusable UI components
│   └── features/              # Clean Architecture feature modules
│       ├── auth/              # Login, Register, Google Sign-In
│       ├── clients/           # Client CRUD
│       ├── invoices/          # Invoice lifecycle management
│       ├── dashboard/         # Analytics & charts
│       ├── settings/          # Profile, currency, theme, language
│       └── onboarding/        # First-run experience
├── functions/                 # Cloud Functions (TypeScript)
│   └── src/
│       ├── invoices/          # PDF generation logic
│       ├── stripe/            # Checkout + Webhook handler
│       ├── emails/            # Invoice & reminder email templates
│       └── cron/              # Daily overdue checker
└── test/                      # Unit, Widget & Integration tests
    └── features/              # Mirrors the lib/features structure
```

### Tech Stack at a Glance

| Layer | Technology |
|---|---|
| **Mobile App** | Flutter (Clean Architecture · BLoC/Cubit · GoRouter) |
| **State Management** | `flutter_bloc` + `equatable` |
| **Backend** | Firebase (Firestore · Auth · Storage · Cloud Messaging) |
| **Cloud Automation** | Google Cloud Functions (Node.js 22 / TypeScript) |
| **Payments** | Stripe Checkout + Webhooks |
| **Emails** | Nodemailer (with PDF attachment + tracking pixel) |
| **PDF Generation** | PDFKit with Arabic (RTL) reshaping support |
| **Localization** | `easy_localization` — Arabic 🇸🇦 & English 🇺🇸 |
| **Charts** | `fl_chart` |
| **Animations** | `lottie` + `animate_do` |
| **Dependency Injection** | `get_it` |
| **Secrets** | `envied` (compile-time env variables) |
| **Testing** | `mocktail` · `bloc_test` · `fake_cloud_firestore` |

---

## 📊 Invoice Status Flow

```
                    ┌─────────────────────────────────┐
                    │           INVOICE CREATED        │
                    └──────────────┬───────────────────┘
                                   │
                                [draft]
                                   │
                          [User submits invoice]
                                   │
                               [pending] ◄──── PDF generated + Email sent to client
                                   │
                    ┌──────────────┴────────────────┐
                    │                               │
              [email opened]              [due date passes]
                    │                               │
                [opened]                        [overdue]
                    │                               │
              [due date passes]            [follow-up email sent]
                    │                               │
                    └──────────────┬────────────────┘
                                   │
                     [Stripe payment confirmed by webhook]
                                   │
                                 [paid] ✅
                         [FCM push notification fired]
```

---

## 🧪 Testing Strategy

The project maintains a comprehensive test suite covering all architecture layers:

```
test/
├── features/
│   ├── auth/           # Auth cubit, repository & data source tests
│   ├── clients/        # Client CRUD + widget tests
│   ├── invoices/       # Calculation logic, cubit & widget tests
│   ├── dashboard/      # Analytics cubit tests
│   └── settings/       # Settings cubit + SharedPreferences tests
└── helpers/            # Shared test mocks & fixtures
```

| Test Type | Coverage |
|---|---|
| **Unit Tests** | Invoice calculations, email validation, Firestore data mapping, Cubits, Repositories, Data Sources |
| **Widget Tests** | Dashboard screen, form inputs, client picker, auth redirect widgets |
| **Integration Tests (E2E)** | Full flow: create invoice → simulate payment → verify status update |

---

## 🔄 CI/CD Pipeline (GitHub Actions)

### Flutter Pipeline
> Triggered on every push/PR to `main`, `master`, or `develop`

```yaml
✅ flutter pub get         # Install dependencies
✅ dart format             # Enforce code formatting
✅ flutter analyze         # Run linter (zero-warning policy)
✅ flutter test --coverage # Run all tests with coverage
✅ flutter build apk       # Build signed release APK
✅ Firebase App Distribution # Auto-deploy to testers (main branch only)
```

### Backend Pipeline
> Triggered on changes to Cloud Functions files

```yaml
✅ npm install     # Install Node dependencies
✅ npm run lint    # ESLint TypeScript checks
✅ npm run build   # Compile TypeScript
✅ firebase deploy # Auto-deploy functions to Google Cloud
```

---

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK `^3.x` (stable channel)
- Node.js `22+` & npm
- Firebase CLI (`npm install -g firebase-tools`)
- A Firebase project with Firestore, Auth, Storage & FCM enabled
- A Stripe account (for payment integration)

### 1. Clone the Repository

```bash
git clone https://github.com/moo-elsayed/Invoify.git
cd Invoify
```

### 2. Configure Environment Variables

```bash
cp .env.example .env
```

Fill in your secrets in `.env`. See [`.env.example`](.env.example) for all required variables.

### 3. Install Flutter Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

### 5. Set Up Cloud Functions (Backend)

```bash
cd functions
cp .env.example .env    # Fill in backend secrets (Stripe, SendGrid, etc.)
npm install
npm run serve           # Run locally with Firebase Emulators
```

---

## 🗄️ Firestore Data Schema

### `users` — Business Owners
| Field | Type | Notes |
|---|---|---|
| `userId` | String | Primary Key (Firebase UID) |
| `businessName` | String | Displayed on invoices & emails |
| `email` | String | |
| `currency` | String | e.g. `USD`, `EGP` |
| `createdAt` | Timestamp | |

### `clients` — Customer Records
| Field | Type | Notes |
|---|---|---|
| `clientId` | String | Primary Key |
| `userId` | String | FK → `users` |
| `name` | String | |
| `email` | String | |
| `phone` | String | |
| `address` | String | |

### `invoices` — Invoice Documents
| Field | Type | Notes |
|---|---|---|
| `invoiceId` | String | Primary Key |
| `userId` / `clientId` | String | FK references |
| `items` | Array | `[{description, quantity, price}]` |
| `taxRate` / `discount` / `totalAmount` | Double | Auto-calculated |
| `currency` | String | Inherited from user settings |
| `status` | String | `draft` / `pending` / `opened` / `overdue` / `paid` |
| `dueDate` | Timestamp | |
| `pdfUrl` | String? | Filled after PDF generation |
| `stripePaymentLink` | String? | Filled after Stripe session creation |

---

## 📁 Clean Architecture — Feature Structure

Each feature follows a strict layered architecture:

```
features/<name>/
├── data/
│   ├── data_sources/     # Firestore API calls
│   ├── models/           # JSON serialization & data models
│   └── repositories/     # Concrete implementations
├── domain/
│   ├── entities/         # Pure business objects
│   ├── repositories/     # Abstract contracts
│   └── use_cases/        # Single-responsibility business operations
└── presentation/
    ├── cubits/           # BLoC/Cubit state management
    ├── views/            # Screen widgets
    └── widgets/          # Feature-specific UI components
```

---

## ✅ Progress Tracker

### Flutter App
- [x] Project Setup & Clean Architecture folder structure
- [x] Firebase configuration
- [x] Authentication (Email + Google Sign-In + Password Reset)
- [x] Settings & User Preferences (Profile, Theme, Language, Currency)
- [x] Client Management screens (CRUD)
- [x] Invoice Creation screen (dynamic items + auto-calculation)
- [x] Invoice List screen (Tabs by status)
- [x] Dashboard & Analytics screen (Charts)
- [x] FCM Push Notification Routing

### Cloud Functions (Node.js / TypeScript)
- [x] PDF Generator function
- [x] Stripe Checkout Link generator
- [x] Stripe Webhook handler (payment confirmation)
- [x] FCM Push Notification trigger
- [x] Invoice Email sender (PDF + payment link)
- [x] Email Tracking Pixel function
- [x] Daily Reminder Cron Job (9:00 AM)

### Testing & DevOps
- [x] Unit Tests (calculations, validation, data mapping, cubits, repos)
- [x] Widget Tests (Dashboard & form screens)
- [x] Integration Tests — End-to-End flow
- [x] GitHub Actions — Flutter pipeline (lint + test + build APK)
- [x] GitHub Actions — Backend pipeline (test + deploy Functions)

---

<div align="center">

Built with ❤️ using **Flutter** · **Firebase** · **Stripe**

*Invoify — From invoice creation to payment collection, fully automated.*

</div>
