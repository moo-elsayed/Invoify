# 📄 System Requirements Specification (SRS)
## Project: Invoify — Automated Invoicing & Payment Tracker

---

## 1. Project Overview & Architecture

**Invoify** هو تطبيق موبايل متكامل **(B2B SaaS)** مصمم لأصحاب الشركات الصغيرة والمستقلين (Freelancers) لإدارة العملاء، إنشاء الفواتير، وأتمتة عمليات المتابعة والتحصيل.

### Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | Flutter (Clean Architecture + BLoC/Cubit) |
| **Backend** | Firebase (Firestore, Auth, Cloud Storage) |
| **Automation** | Google Cloud Functions (Node.js / TypeScript) |
| **Payments** | Stripe (Checkout + Webhooks) |
| **Emailing** | SendGrid / Nodemailer |

---

## 2. Database Schema (Firebase Firestore)

### A. `users` Collection — صاحب العمل

| Field | Type | Notes |
|---|---|---|
| `userId` | String | Primary Key |
| `businessName` | String | |
| `email` | String | |
| `currency` | String | e.g. `USD`, `EGP` |
| `createdAt` | Timestamp | |

---

### B. `clients` Collection — العملاء

| Field | Type | Notes |
|---|---|---|
| `clientId` | String | Primary Key |
| `userId` | String | FK → `users.userId` (creator) |
| `name` | String | |
| `email` | String | |
| `phone` | String | |
| `address` | String | |

---

### C. `invoices` Collection — الفواتير

| Field | Type | Notes |
|---|---|---|
| `invoiceId` | String | Primary Key |
| `userId` | String | FK → `users.userId` |
| `clientId` | String | FK → `clients.clientId` |
| `clientName` | String | Denormalized for display |
| `items` | Array<Object> | [{description, quantity, price}] |
| `taxRate` | Double | |
| `discount` | Double | |
| `totalAmount` | Double | |
| `currency` | String | |
| `status` | String | draft / pending / opened / overdue / paid |
| `dueDate` | Timestamp | |
| `createdAt` | Timestamp | |
| `pdfUrl` | String? | Nullable — filled after PDF generation |
| `stripePaymentLink` | String? | Nullable — filled after Stripe session |

---

## 3. Functional Requirements

### 3.1 Flutter Mobile Application (Client-Side)

#### 🔐 Authentication
- [ ] تسجيل الدخول وإنشاء حساب بـ **Email/Password** و **Google Sign-In**.
- [ ] **Session Persistence** — المستخدم يبقى مسجلاً دخوله بين الجلسات.

#### 👥 Client Management
- [ ] شاشات **CRUD** كاملة: إضافة، تعديل، حذف، واستعراض بيانات العملاء.

#### 🧾 Invoice Lifecycle
- [ ] **إنشاء فاتورة**: اختيار عميل مسجل + إضافة عناصر (Items) ديناميكياً مع حساب تلقائي للمجموع والضرائب والخصومات.
- [ ] **استعراض الفواتير**: قائمة مقسمة بـ **Tabs** حسب الحالة: الكل / مدفوعة / متأخرة / قيد الانتظار.

#### 📊 Dashboard & Business Analytics
- [ ] رسومات بيانية (Charts) توضح:
  - إجمالي الأرباح الشهرية (Monthly Earnings).
  - حجم المبالغ المتأخرة (Total Overdue).
  - قائمة بأكثر العملاء نشاطاً.

#### 🔗 Routing & Deep Linking
- [ ] **Notification Routing**: الضغط على Push Notification يفتح شاشة تفاصيل الفاتورة المعنية مباشرة.
- [ ] **Deep Linking (App Links)**: رابط ويب في الإيميل يفتح التطبيق مباشرة على الفاتورة المعنية.

---

### 3.2 Cloud Functions & Backend Automation (Server-Side)

#### 📑 Invoice PDF Generator
- [ ] **Trigger**: تغيير حالة الفاتورة من `draft` إلى `pending` في الموبايل.
- [ ] **Action**:
  1. قراءة بيانات الفاتورة من Firestore.
  2. إنشاء ملف PDF احترافي للفاتورة.
  3. رفع الـ PDF على Firebase Storage.
  4. تحديث حقل `pdfUrl` في وثيقة الفاتورة.

#### 💳 Stripe Checkout Link & Webhooks
- [ ] **Payment Link**: إنشاء Stripe Checkout Session URL بقيمة الفاتورة وتحديث حقل `stripePaymentLink`.
- [ ] **Stripe Webhook** (عند تأكيد الدفع الناجح):
  1. تحديث حالة الفاتورة إلى `paid` في Firestore.
  2. إرسال FCM Push Notification فوري للموبايل.

#### 📧 Automated Emailing & Email Tracking
- [ ] **Invoice Email**: فور جاهزية الـ PDF والـ Payment Link، إرسال إيميل رسمي للعميل يحتوي على:
  - PDF مرفق.
  - رابط الدفع (Stripe Checkout).
- [ ] **Email Opened Tracker (Tracking Pixel)**:
  - دمج صورة 1x1 px مخفية في الإيميل تشير إلى Cloud Function.
  - فتح العميل للإيميل يستدعي الـ Function تلقائياً.
  - تحديث حالة الفاتورة إلى `opened` مع تسجيل الوقت.

#### ⏰ Automated Daily Reminders (Cron Job)
- [ ] **Schedule**: كل يوم الساعة 9:00 صباحاً.
- [ ] **Logic**:
  1. البحث عن الفواتير ذات حالة `pending` أو `opened` والتي تجاوزت الـ `dueDate`.
  2. تحديث حالتها إلى `overdue`.
  3. إرسال Follow-up Email تذكيري تلقائي للعميل.

---

## 4. Technical Quality Standards

### 4.1 Testing Strategy

| نوع الاختبار | ما يتم اختباره |
|---|---|
| **Unit Tests** | Business Logic: حسابات الفواتير، التحقق من الإيميلات، Data Mapping |
| **Widget Tests** | UI Validation: شاشات Dashboard وإدخال البيانات |
| **Integration Tests (E2E)** | رحلة كاملة: إنشاء فاتورة → محاكاة دفع → التحقق من تغيير الحالة |

---

### 4.2 CI/CD Pipeline (GitHub Actions)

#### Flutter Pipeline
> يُشغَّل مع كل Push أو PR على الـ main branch.

- [ ] `flutter pub get` — سحب الاعتماديات.
- [ ] `flutter analyze` — تشغيل الـ Linter.
- [ ] تشغيل الـ Tests (Unit + Widget + Integration).
- [ ] بناء Signed Release APK.

#### Backend Pipeline
> يُشغَّل عند التعديل على ملفات Cloud Functions وعمل Push.

- [ ] اختبار كود الـ Functions.
- [ ] Auto-Deploy للـ Functions على Google Cloud Console.

---

## 5. Invoice Status Flow

```
draft ──(submit)──► pending ──(email opened)──► opened
                       │                           │
                  (overdue check)            (overdue check)
                       │                           │
                       └──────────► overdue ◄──────┘
                                       │
                              (payment confirmed)
                                       │
                                    paid ✅
```

---

## 6. Progress Tracker

> استخدم هذا القسم لتتبع تقدم التطوير. ✅ = Done | 🔄 = In Progress | ⬜ = Todo

### Flutter App
- ⬜ Project Setup & Clean Architecture folder structure
- ⬜ Firebase configuration
- ⬜ Authentication (Email + Google Sign-In)
- ⬜ Client Management screens (CRUD)
- ⬜ Invoice Creation screen (dynamic items + auto-calculation)
- ⬜ Invoice List screen (Tabs by status)
- ⬜ Dashboard & Analytics screen (Charts)
- ⬜ Deep Linking & Notification Routing

### Cloud Functions (Node.js / TypeScript)
- ⬜ PDF Generator function (Storage Trigger / Callable)
- ⬜ Stripe Checkout Link generator
- ⬜ Stripe Webhook handler (payment confirmation)
- ⬜ FCM Push Notification trigger
- ⬜ Invoice Email sender (PDF + payment link)
- ⬜ Email Tracking Pixel function
- ⬜ Daily Reminder Cron Job (9:00 AM)

### Testing & DevOps
- ⬜ Unit Tests (invoice calculations, email validation, data mapping)
- ⬜ Widget Tests (Dashboard & form screens)
- ⬜ Integration Tests — End-to-End flow
- ⬜ GitHub Actions — Flutter pipeline (lint + test + build APK)
- ⬜ GitHub Actions — Backend pipeline (test + deploy Functions)
