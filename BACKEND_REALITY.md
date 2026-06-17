# Nasiya Pro Backend — Reality Documentation (Full Updated Version)

This document describes the CURRENT backend reality based on actual implemented code.

Code is truth.

This is not ideal architecture documentation.
This is not future planning.
This is real implementation state for backend + mobile team alignment.

---

# 1. Project Overview

## Nasiya Pro

B2B SaaS multi-tenant debt management system for:

* shops
* pharmacies
* mini markets
* distributors
* small businesses

Purpose:

Business owners manage:

* customer debts
* repayments
* overdue debts
* employee actions
* transparency
* branch operations
* reports
* trust

This is a money-control system.

Auditability matters.
Consistency matters.
Trust matters.

---

# 2. Tech Stack

* Backend: NestJS
* Language: TypeScript
* ORM: TypeORM
* Database: PostgreSQL
* Multi-tenancy: schema-per-tenant
* Cache / Queue: Redis + BullMQ
* Auth: JWT access token + opaque refresh token
* Audit logging: Event-based audit system

Important:

BullMQ is configured but queue processors are not implemented yet.

---

# 3. Current Roles (Backend Reality)

Currently implemented roles:

* SUPER_ADMIN
* OWNER
* MANAGER
* SELLER
* ACCOUNTANT

Important:

There is NO STAFF role yet.

Business target is:

* OWNER
* STAFF
* PLATFORM_ADMIN

But backend still uses the older expanded role model.

---

# 4. Authentication

## Implemented Endpoints

* POST /api/v1/auth/register-owner
* POST /api/v1/auth/login
* POST /api/v1/auth/refresh
* POST /api/v1/auth/logout

Still missing:

* first login forced password change
* forgot password
* password reset
* logout all sessions
* owner reset staff password

---

# 5. OWNER Self Registration

## Endpoint

POST /api/v1/auth/register-owner

Public endpoint.

---

## Request Body

```json
{
  "full_name": "Ali Valiyev",
  "phone": "+998901112233",
  "password": "StrongPassword123",
  "business_name": "Ali Med Farm"
}
```

---

## Business Rule

Only business owner (Director / OWNER) can self-register.

Employees must NEVER self-register.

Employees are created only by OWNER inside the system.

This is strict.

---

## Critical Validation Rule

## One phone number = one business context

If the same phone number already exists anywhere in the system:

* OWNER
* employee
* any existing user in any tenant

registration must fail.

This prevents:

* duplicate businesses
* employee self-registration abuse
* parallel fake tenant creation

---

## Error Message

```text
This phone number is already linked to an existing business account.
Please log in or use another phone number.
```

---

# 6. Tenant Provisioning Flow

Implemented as real provisioning flow.

Inside a single QueryRunner transaction:

1. Create tenant row (`isActive = false`)
2. Create PostgreSQL schema (`tenant_<slug>`)
3. Create default branch (`Main Branch`)
4. Create OWNER user
5. Link OWNER to tenant + branch
6. Mark tenant `isActive = true`
7. Commit transaction

If anything fails:

* rollback happens
* no partial tenant remains
* no broken half-created account exists

This is rollback-safe provisioning.

No half-success allowed.

---

# 7. Auto Login After Registration

After successful commit:

System automatically issues:

* JWT access token (15 min)
* opaque refresh token (`tokenId.secret`)

Refresh token is stored server-side.

Response:

```json
{
  "user": {},
  "accessToken": "...",
  "refreshToken": "..."
}
```

No second manual login required.

This improves onboarding conversion.

---

# 8. Login

## Endpoint

POST /api/v1/auth/login

Uses:

* phone
* password

Validates:

* user exists
* user active
* password correct

Returns:

* user
* accessToken
* refreshToken

Updates:

* lastLoginAt
* audit event

---

# 9. Refresh Token System

Refresh token is NOT JWT.

It is opaque:

```text
tokenId.secret
```

Stored in table:

`auth_refresh_tokens`

Fields:

* id
* userId
* familyId
* secretHash
* expiresAt
* revokedAt
* replacedByTokenId

Implemented:

* hashed storage
* token rotation
* family chain
* reuse detection
* family revocation
* suspicious activity detection

This is production-safe refresh handling.

---

# 10. Logout

## Endpoint

POST /api/v1/auth/logout

Real server-side logout.

Behavior:

* validates refresh token
* revokes refresh token
* sets revokedAt

Currently:

Only current session logout exists.

Logout-all is not implemented.

---

# 11. Core Modules

Implemented modules:

* AuthModule
* TenantsModule
* UsersModule
* BranchesModule
* CustomersModule
* DebtsModule
* PaymentsModule
* AuditModule
* ReportsModule
* DatabaseModule
* RedisModule

---

# 12. Core Entities

## tenants

* id
* name
* slug
* isActive
* settings
* createdAt

## users

* id
* fullName
* phone
* passwordHash
* role
* tenantId
* branchId
* isActive
* lastLoginAt
* deletedAt

## branches

* id
* name
* tenantId
* isActive

## customers

* id
* fullName
* phone
* address
* trustScore
* branchId
* createdBy

## debts

* id
* debtNumber
* customerId
* branchId
* totalAmount
* paidAmount
* remainingAmount
* dueDate
* status
* createdBy

## payments

* id
* debtId
* amount
* method
* receivedBy
* verifiedBy

## audit_logs

* id
* tenantId
* userId
* action
* entityType
* entityId
* oldValue
* newValue
* ipAddress

## auth_refresh_tokens

* id
* userId
* familyId
* secretHash
* revokedAt

---

# 13. API Endpoints

## Auth

* register-owner
* login
* refresh
* logout

## Users

* create user
* list users
* get user
* deactivate user

## Branches

* create branch
* list branches
* branch details

## Customers

* create customer
* list customers
* search customer
* customer details
* history
* trust score

## Debts

* create debt
* list debts
* debt details
* update debt
* soft delete debt
* debt history

## Payments

* create payment
* list payments
* payment details
* verify payment

## Reports

* dashboard report

## Audit

* audit logs
* entity history

---

# 14. Multi-Tenancy

Current strategy:

schema-per-tenant

Implementation:

* tenant schema created per business
* request-scoped QueryRunner
* SET search_path to tenant schema

Problem:

Many repositories still use default injected repositories.

This means:

tenant isolation is still partially inconsistent.

This is a major high-risk area.

---

# 15. Audit Logging

Audit is event-based.

Sources:

* @AuditLog decorator
* AuthService manual events

Stored for:

* login
* registration
* debt actions
* payment actions
* verification
* suspicious activity

Important:

Audit is best-effort.

It is not fully transactionally tied to business writes yet.

---

# 16. Current Technical Debt

## Major

### Tenant isolation incomplete

Most dangerous issue.

Repositories still bypass tenant-scoped EntityManager.

### Role model mismatch

Backend roles ≠ real business roles.

### No first login password change

Needed for staff flow.

### No brute-force protection

Missing:

* failed login counters
* lockouts

### Debt number generation unsafe

In-memory counter exists.

Unsafe for production.

### No tenant schema migrations

Still TODO.

### No foreign key safety

UUID links exist without strong relational guarantees.

### BullMQ not actually used

Configured but not implemented.

---

# 17. Mobile Team Important Notes

Mobile must support:

* owner self-registration
* auto-login after registration
* login
* refresh token rotation
* real logout

Mobile must NOT build yet:

* forgot password
* first login forced password change
* staff public registration
* logout all sessions
* platform admin dashboard

Do not build fake unsupported flows.

Backend truth wins.

---

# 18. Final Reality

System is now a real SaaS onboarding system.

Before:

manual tenant creation

Now:

self-service owner registration
→ auto login
→ instant product usage

This is the biggest MVP milestone.

Still remaining:

* tenant isolation cleanup
* staff flow polish
* role simplification
* security hardening

But the product is now alive.
