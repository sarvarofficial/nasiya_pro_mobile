# Nasiya Pro — Mobile API Documentation

> **Base URL:** `http://localhost:3000`  
> **API Prefix:** `/api/v1`  
> **Full Base:** `http://localhost:3000/api/v1`

---

## Authentication

- Every request (except login & refresh) must include:  
  `Authorization: Bearer <accessToken>`
- `accessToken` expires in **15 minutes**
- Use `refreshToken` (valid **30 days**) to get new tokens without re-login

---

## Standard Response Format

```json
{
  "success": true,
  "data": {},
  "meta": { "page": 1, "limit": 20, "total": 120 },
  "error": null
}
```

**Error response:**
```json
{
  "success": false,
  "data": null,
  "meta": null,
  "error": "Error message here"
}
```

---

## Enums

### Role
| Value | Description |
|---|---|
| `super_admin` | Platform admin |
| `owner` | Tenant owner — full access |
| `manager` | Branch manager |
| `seller` | Creates debts & receives payments |
| `accountant` | Read-only reports |

### DebtStatus
| Value | Description |
|---|---|
| `active` | No payment made yet |
| `partial` | Partially paid |
| `paid` | Fully paid |
| `overdue` | Past due date |
| `written_off` | Written off |

### PaymentMethod
| Value | Description |
|---|---|
| `cash` | Naqd pul |
| `card` | Karta |
| `transfer` | O'tkazma |

### AuditSeverity
| Value |
|---|
| `info` |
| `warning` |
| `critical` |

---

## 1. AUTH

### POST `/api/v1/auth/login`
> 🔓 Public — no token required

**Request:**
```json
{
  "phone": "+998901234567",
  "password": "password123"
}
```

**Response `data`:**
```json
{
  "user": {
    "id": "uuid",
    "fullName": "Ali Valiyev",
    "phone": "+998901234567",
    "role": "owner",
    "branchId": "uuid"
  },
  "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiJ9..."
}
```

---

### POST `/api/v1/auth/refresh`
> 🔓 Public

**Request:**
```json
{ "refreshToken": "eyJhbGciOiJIUzI1NiJ9..." }
```

**Response `data`:**
```json
{
  "accessToken": "...",
  "refreshToken": "..."
}
```

---

## 2. USERS

### POST `/api/v1/users`
**Roles:** `owner`

**Request:**
```json
{
  "fullName": "Sardor Toshmatov",
  "phone": "+998901112233",
  "password": "securepass",
  "role": "seller",
  "branchId": "uuid"
}
```

**Response `data`:**
```json
{
  "id": "uuid",
  "fullName": "Sardor Toshmatov",
  "phone": "+998901112233",
  "role": "seller",
  "tenantId": "uuid",
  "branchId": "uuid",
  "isActive": true,
  "createdAt": "2025-01-01T00:00:00Z"
}
```

---

### GET `/api/v1/users`
**Roles:** `owner`, `manager`  
**Response `data`:** Array of user objects

---

### GET `/api/v1/users/:id`
**Roles:** `owner`, `manager`

---

### PATCH `/api/v1/users/:id/deactivate`
**Roles:** `owner`  
**Response `data`:** `{ "message": "User deactivated" }`

---

## 3. BRANCHES

### POST `/api/v1/branches`
**Roles:** `owner`

**Request:**
```json
{
  "name": "Yunusobod filiali",
  "address": "Yunusobod 7-mavze",
  "phone": "+998712345678"
}
```

**Response `data`:**
```json
{
  "id": "uuid",
  "name": "Yunusobod filiali",
  "address": "...",
  "phone": "...",
  "tenantId": "uuid",
  "isActive": true,
  "createdAt": "..."
}
```

---

### GET `/api/v1/branches`
**Roles:** `owner`, `manager`, `accountant`

---

### GET `/api/v1/branches/:id`
**Roles:** `owner`, `manager`

---

## 4. CUSTOMERS

### POST `/api/v1/customers`
**Roles:** `owner`, `manager`, `seller`

**Request:**
```json
{
  "fullName": "Bobur Rahimov",
  "phone": "+998907654321",
  "address": "Chilonzor 12-uy"
}
```

**Response `data`:**
```json
{
  "id": "uuid",
  "fullName": "Bobur Rahimov",
  "phone": "+998907654321",
  "address": "...",
  "trustScore": 100,
  "totalDebtCount": 0,
  "totalOverdueCount": 0,
  "branchId": "uuid",
  "createdAt": "..."
}
```

---

### GET `/api/v1/customers`
**Roles:** All roles  
**Response `data`:** Array of customers

---

### GET `/api/v1/customers/search?q=Bobur`
**Roles:** `owner`, `manager`, `seller`  
**Query:** `q` — search by name or phone

---

### GET `/api/v1/customers/:id`
**Roles:** All roles

---

### GET `/api/v1/customers/:id/history`
**Roles:** `owner`, `manager`  
**Response `data`:** Array of audit log entries for this customer

---

### GET `/api/v1/customers/:id/trust-score`
**Roles:** `owner`, `manager`

**Response `data`:**
```json
{
  "customerId": "uuid",
  "trustScore": 90,
  "totalDebtCount": 5,
  "totalOverdueCount": 1
}
```

---

## 5. DEBTS

### POST `/api/v1/debts`
**Roles:** `owner`, `manager`, `seller`

**Request:**
```json
{
  "customerId": "uuid",
  "totalAmount": 500000,
  "dueDate": "2025-06-01",
  "note": "Telefon uchun",
  "items": [
    { "product": "iPhone 15", "qty": 1, "price": 500000 }
  ]
}
```

> ⚠️ `branchId` and `createdBy` are taken from JWT — do NOT send in body.

**Response `data`:**
```json
{
  "id": "uuid",
  "debtNumber": "#DBT-2025-00001",
  "customerId": "uuid",
  "branchId": "uuid",
  "totalAmount": "500000.00",
  "paidAmount": "0.00",
  "remainingAmount": "500000.00",
  "status": "active",
  "dueDate": "2025-06-01",
  "note": "...",
  "items": [...],
  "createdBy": "uuid",
  "createdAt": "..."
}
```

---

### GET `/api/v1/debts`
**Roles:** All roles  
**Query params:**

| Param | Type | Values |
|---|---|---|
| `status` | DebtStatus | `active`, `partial`, `paid`, `overdue`, `written_off` |
| `page` | number | `1` |
| `limit` | number | `20` (max 100) |

**Response:**
```json
{
  "success": true,
  "data": [...],
  "meta": { "page": 1, "limit": 20, "total": 54 }
}
```

---

### GET `/api/v1/debts/:id`
**Roles:** All roles

---

### GET `/api/v1/debts/:id/history`
**Roles:** `owner`, `manager`, `accountant`  
**Response `data`:** Full audit trail array for this debt

---

### PATCH `/api/v1/debts/:id`
**Roles:** `owner`, `manager`

**Request (all optional):**
```json
{
  "status": "overdue",
  "dueDate": "2025-07-01",
  "note": "Yangi muddatga o'tkazildi"
}
```

---

### DELETE `/api/v1/debts/:id`
**Roles:** `owner` only  
> ⚠️ Soft delete only — data is NOT permanently removed.

**Response `data`:** `{ "message": "Debt soft deleted" }`

---

## 6. PAYMENTS

### POST `/api/v1/payments`
**Roles:** `owner`, `manager`, `seller`

**Request:**
```json
{
  "debtId": "uuid",
  "amount": 100000,
  "method": "cash",
  "proofUrl": "https://..."
}
```

**Response `data`:**
```json
{
  "id": "uuid",
  "debtId": "uuid",
  "amount": "100000.00",
  "method": "cash",
  "receivedBy": "uuid",
  "verifiedBy": null,
  "proofUrl": null,
  "isSuspicious": false,
  "suspiciousReason": null,
  "paidAt": "2025-04-23T10:00:00Z"
}
```

> ⚠️ If `isSuspicious: true` — owner/manager receives push notification automatically.

**Suspicious triggers:**
- Payment between 00:00–05:00
- Same user sends 10+ payments in one day
- Same amount on same debt within 5 minutes

---

### GET `/api/v1/payments?debtId=<uuid>`
**Roles:** All roles  
**Required query:** `debtId`

---

### GET `/api/v1/payments/:id`
**Roles:** All roles

---

### PATCH `/api/v1/payments/:id/verify`
**Roles:** `owner`, `manager`  
No body needed — sets `verifiedBy` to current user.

---

## 7. REPORTS

### GET `/api/v1/reports/dashboard`
**Roles:** `owner`, `manager`, `accountant`

**Response `data`:**
```json
{
  "debts": {
    "total": 124,
    "active": 80,
    "overdue": 12,
    "paid": 32
  },
  "amounts": {
    "totalDebt": 15000000,
    "totalPaid": 8000000,
    "totalRemaining": 7000000
  },
  "today": {
    "paymentsCount": 5,
    "paymentsTotal": 500000
  }
}
```

---

## 8. AUDIT LOGS

### GET `/api/v1/audit-logs`
**Roles:** `owner`, `accountant`

**Query params:**
| Param | Type | Example |
|---|---|---|
| `entity` | string | `debt`, `payment`, `user` |
| `user` | uuid | user ID |
| `from` | ISO date | `2025-01-01` |
| `to` | ISO date | `2025-12-31` |
| `severity` | AuditSeverity | `info`, `warning`, `critical` |
| `page` | number | `1` |
| `limit` | number | `50` |

**Audit log object:**
```json
{
  "id": 1,
  "tenantId": "uuid",
  "userId": "uuid",
  "userRole": "seller",
  "branchId": "uuid",
  "action": "DEBT_CREATED",
  "entityType": "debt",
  "entityId": "uuid",
  "oldValue": null,
  "newValue": { "totalAmount": 500000 },
  "diff": null,
  "ipAddress": "192.168.1.1",
  "deviceInfo": { "userAgent": "Flutter/3.0", "appVersion": "1.0.0" },
  "sessionId": "sess_abc123",
  "severity": "info",
  "createdAt": "2025-04-23T10:00:00Z"
}
```

---

### GET `/api/v1/audit-logs/entity/:entityType/:entityId`
**Roles:** `owner`, `manager`, `accountant`  
Example: `GET /api/v1/audit-logs/entity/debt/some-debt-uuid`

---

## Flutter Integration Notes

### Required headers for every request:
```dart
{
  'Authorization': 'Bearer $accessToken',
  'Content-Type': 'application/json',
  'X-App-Version': '1.0.0',
  'X-Session-Id': sessionId,
}
```

### Token Refresh Flow:
```
1. Store accessToken + refreshToken on login
2. On any 401 response:
   a. Call POST /api/v1/auth/refresh
   b. Save new accessToken + refreshToken
   c. Retry original failed request
3. On refresh 401: force user to re-login
```

### Offline Support:
| Endpoint | Offline |
|---|---|
| `POST /api/v1/debts` | ✅ store locally, sync on connect |
| `POST /api/v1/payments` | ✅ store locally, sync on connect |
| `GET /api/v1/customers` | ✅ cache for offline view |
| `GET /api/v1/reports/*` | ❌ online only |
| `GET /api/v1/audit-logs` | ❌ online only |

### HTTP Status Codes:
| Code | Meaning |
|---|---|
| `200` | Success |
| `201` | Created |
| `400` | Validation error |
| `401` | Token missing or expired |
| `403` | Role not permitted |
| `404` | Not found |
| `409` | Conflict (duplicate data) |
| `500` | Server error |

---

## All Endpoints Summary

```
POST   /api/v1/auth/login
POST   /api/v1/auth/refresh

POST   /api/v1/users
GET    /api/v1/users
GET    /api/v1/users/:id
PATCH  /api/v1/users/:id/deactivate

POST   /api/v1/branches
GET    /api/v1/branches
GET    /api/v1/branches/:id

POST   /api/v1/customers
GET    /api/v1/customers
GET    /api/v1/customers/search?q=
GET    /api/v1/customers/:id
GET    /api/v1/customers/:id/history
GET    /api/v1/customers/:id/trust-score

POST   /api/v1/debts
GET    /api/v1/debts
GET    /api/v1/debts/:id
GET    /api/v1/debts/:id/history
PATCH  /api/v1/debts/:id
DELETE /api/v1/debts/:id

POST   /api/v1/payments
GET    /api/v1/payments?debtId=
GET    /api/v1/payments/:id
PATCH  /api/v1/payments/:id/verify

GET    /api/v1/reports/dashboard

GET    /api/v1/audit-logs
GET    /api/v1/audit-logs/entity/:entityType/:entityId
```
